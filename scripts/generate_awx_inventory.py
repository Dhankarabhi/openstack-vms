#!/usr/bin/env python3
"""
Generate AWX/Ansible Inventory from Terraform Output
Usage: python3 generate_awx_inventory.py <terraform_output.json> <awx_inventory.ini> <environment>
"""

import json
import sys
from pathlib import Path


def parse_terraform_output(json_file):
    """Parse Terraform output JSON file"""
    with open(json_file, 'r') as f:
        data = json.load(f)
    return data


def extract_vm_details(terraform_output, env_prefix):
    """Extract VM details from Terraform output"""
    vms = {}
    
    # Look for VM details output (dev_vm_details or test_vm_details)
    vm_details_key = f"{env_prefix}_vm_details"
    
    if vm_details_key not in terraform_output:
        print(f"Warning: {vm_details_key} not found in Terraform output")
        return vms
    
    vm_details = terraform_output[vm_details_key]['value']
    
    for vm_key, vm_info in vm_details.items():
        vm_name = vm_info.get('name', vm_key)
        
        # Prefer floating IP, fallback to private IP
        ansible_host = vm_info.get('fip') or vm_info.get('private_ip')
        
        if ansible_host:
            vms[vm_key] = {
                'name': vm_name,
                'ansible_host': ansible_host,
                'private_ip': vm_info.get('private_ip'),
                'fip': vm_info.get('fip'),
                'flavor': vm_info.get('flavor'),
                'vm_key': vm_key
            }
    
    return vms


def generate_inventory(vms, output_file, environment):
    """Generate Ansible inventory file"""
    
    with open(output_file, 'w') as f:
        # Header
        f.write(f"# AWX Inventory for {environment.upper()} Environment\n")
        f.write(f"# Generated from Terraform output\n")
        f.write(f"# Date: $(date)\n\n")
        
        # All VMs group
        f.write(f"[{environment}_all_vms]\n")
        for vm_key in sorted(vms.keys()):
            vm = vms[vm_key]
            f.write(f"{vm['name']} ansible_host={vm['ansible_host']}\n")
        
        f.write("\n")
        
        # VMs with FIPs (accessible from outside)
        fip_vms = {k: v for k, v in vms.items() if v.get('fip')}
        if fip_vms:
            f.write(f"[{environment}_public_vms]\n")
            for vm_key in sorted(fip_vms.keys()):
                vm = fip_vms[vm_key]
                f.write(f"{vm['name']} ansible_host={vm['fip']}\n")
            f.write("\n")
        
        # VMs without FIPs (internal only)
        private_vms = {k: v for k, v in vms.items() if not v.get('fip')}
        if private_vms:
            f.write(f"[{environment}_private_vms]\n")
            for vm_key in sorted(private_vms.keys()):
                vm = private_vms[vm_key]
                f.write(f"{vm['name']} ansible_host={vm['private_ip']}\n")
            f.write("\n")
        
        # Variables section
        f.write(f"[{environment}_all_vms:vars]\n")
        f.write(f"ansible_user=ubuntu\n")
        f.write(f"ansible_ssh_common_args='-o StrictHostKeyChecking=no'\n")
        f.write(f"environment={environment}\n")


def main():
    if len(sys.argv) < 3:
        print("Usage: python3 generate_awx_inventory.py <terraform_output.json> <awx_inventory.ini> [environment]")
        sys.exit(1)
    
    json_file = sys.argv[1]
    output_file = sys.argv[2]
    environment = sys.argv[3] if len(sys.argv) > 3 else "dev"
    
    if not Path(json_file).exists():
        print(f"Error: File {json_file} not found")
        sys.exit(1)
    
    print(f"Parsing Terraform output from: {json_file}")
    terraform_output = parse_terraform_output(json_file)
    
    print(f"Extracting VM details for environment: {environment}")
    vms = extract_vm_details(terraform_output, environment)
    
    if not vms:
        print("Warning: No VMs found in Terraform output")
        sys.exit(1)
    
    print(f"Found {len(vms)} VMs")
    print(f"Generating AWX inventory: {output_file}")
    generate_inventory(vms, output_file, environment)
    
    print(f"✅ Inventory file generated successfully: {output_file}")
    print(f"\nVM Summary:")
    for vm_key, vm in sorted(vms.items()):
        access = "Public" if vm.get('fip') else "Private"
        print(f"  - {vm['name']}: {vm['ansible_host']} ({access})")


if __name__ == "__main__":
    main()
