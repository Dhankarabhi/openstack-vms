############################################################
# Root-level outputs (from module)
############################################################

output "dev_vm_fips" {
  description = "Floating IPs of all VMs"
  value       = module.vms.vm_fips
}

output "dev_boot_volumes" {
  description = "Boot volume details for snapshot/clone-based VMs"
  value       = module.vms.boot_volumes
}

output "dev_data_volumes" {
  description = "Data volume details attached to VMs"
  value       = module.vms.data_volumes
}

output "dev_data_volumes_by_vm" {
  description = "Data volumes grouped by VM"
  value       = module.vms.data_volumes_by_vm
}

output "dev_vm_details" {
  description = "Detailed VM information including IP, volumes, flavor, and status"
  value       = module.vms.vm_details
}

output "dev_vm_storage_summary" {
  description = "Storage summary per VM"
  value       = module.vms.vm_storage_summary
}

############################################################
# Save outputs and generate AWX inventory
############################################################

resource "null_resource" "save_outputs" {
  depends_on = [
    module.vms
  ]

  triggers = {
    always_run = timestamp()
    vm_fips = jsonencode(module.vms.vm_fips)
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
  depends_on  = [null_resource.save_outputs]
}

output "awx_inventory_file" {
  description = "Path to generated AWX inventory file"
  value       = "${path.module}/../terraform_outputs/awx_inventory.ini"
  depends_on  = [null_resource.save_outputs]
}
