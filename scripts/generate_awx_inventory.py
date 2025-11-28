#!/usr/bin/env python3
import json
import sys

if len(sys.argv) != 3:
    print("Usage: generate_awx_inventory.py <terraform_output.json> <awx_inventory.ini>")
    sys.exit(1)

tf_json_file = sys.argv[1]
inventory_file = sys.argv[2]

# Load Terraform outputs
with open(tf_json_file) as f:
    tf_data = json.load(f)

# --- Look for VM details (which contains both FIPs and private IPs) ---
vm_details_key = None
for key in tf_data.keys():
    if "vm_details" in key.lower():
        vm_details_key = key
        break

# Fall back to looking for floating IPs only
fip_key = None
if not vm_details_key:
    for key in tf_data.keys():
        if "vm_fips" in key.lower() or "fip" in key.lower():
            fip_key = key
            break

if not vm_details_key and not fip_key:
    print("❌ No VM data found in Terraform outputs!")
    print(f"Available keys: {list(tf_data.keys())}")
    sys.exit(1)

# --- Build inventory from VM details (preferred) or floating IPs ---
vms_to_add = {}

if vm_details_key:
    vm_details = tf_data[vm_details_key].get("value", {})
    for vm_name, details in vm_details.items():
        # Prefer floating IP, fall back to private IP
        ip = details.get("fip") or details.get("private_ip")
        if ip:
            vms_to_add[vm_name] = ip
elif fip_key:
    vms = tf_data[fip_key].get("value", {})
    for name, ip in vms.items():
        if ip:
            vms_to_add[name] = ip

if not vms_to_add:
    print("⚠️  No VMs with accessible IPs found!")
    print("✅ Creating empty AWX inventory file")
    with open(inventory_file, "w") as f:
        f.write("[all_vms]\n")
        f.write("# No VMs with floating or private IPs\n")
    sys.exit(0)

# --- Write AWX inventory ---
with open(inventory_file, "w") as f:
    f.write("[all_vms]\n")
    for name, ip in vms_to_add.items():
        f.write(f"{name} ansible_host={ip}\n")

print(f"✅ AWX inventory generated successfully at: {inventory_file}")
print(f"📋 VMs added: {len(vms_to_add)}")
for name, ip in vms_to_add.items():
    print(f"   - {name}: {ip}")
