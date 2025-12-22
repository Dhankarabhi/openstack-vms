############################################################
# Root-level outputs (from module)
############################################################

output "dev_vm_fips" {
  description = "Floating IPs of all VMs"
  value       = module.vms.vm_fips
}

output "dev_volumes" {
  description = "Volume details attached to VMs"
  value       = module.vms.volumes
}

output "dev_vm_details" {
  description = "Detailed VM information including IP, volume, flavor, and status"
  value       = module.vms.vm_details
}

############################################################
# Save outputs and generate AWX inventory
############################################################

resource "null_resource" "save_outputs" {
  triggers = {
    always_run = timestamp()  # ensures it runs every apply
  }

  provisioner "local-exec" {
    command = <<EOT
mkdir -p ${path.module}/../terraform_outputs

# Save Terraform outputs to JSON
terraform output -json > ${path.module}/../terraform_outputs/terraform_output.json

# Generate AWX inventory from Terraform output JSON
python3 ${path.module}/../../scripts/generate_awx_inventory.py \
  ${path.module}/../terraform_outputs/terraform_output.json \
  ${path.module}/../terraform_outputs/awx_inventory.ini
EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

############################################################
# Output file locations
############################################################

output "terraform_outputs_file" {
  description = "Path to stored Terraform outputs JSON"
  value       = "${path.module}/../terraform_outputs/terraform_output.json"
}

output "awx_inventory_file" {
  description = "Path to generated AWX inventory file"
  value       = "${path.module}/../terraform_outputs/awx_inventory.ini"
}
