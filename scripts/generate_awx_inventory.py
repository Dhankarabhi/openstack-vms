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

# --- Auto-detect the key that holds floating IPs ---
fip_key = None
for key in tf_data.keys():
    if "fip" in key.lower() or "floating_ip" in key.lower():
        fip_key = key
        break

if not fip_key:
    print("❌ No floating IP data found in Terraform outputs!")
    sys.exit(1)

vms = tf_data[fip_key].get("value", {})

if not vms:
    print("❌ Floating IP list is empty in Terraform output!")
    sys.exit(1)

# --- Write AWX inventory ---
with open(inventory_file, "w") as f:
    f.write("[all_vms]\n")
    for name, ip in vms.items():
        f.write(f"{name} ansible_host={ip}\n")

print(f"✅ AWX inventory generated successfully at: {inventory_file}")
print(f"🧩 Using Terraform key: {fip_key}")
