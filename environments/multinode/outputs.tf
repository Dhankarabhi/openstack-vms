############################################################
# environments/developer/outputs.tf
############################################################

############################################################
# Root-level outputs (from module)
############################################################
output "developer_vm_fips" {
  description = "Floating IPs of all VMs"
  value       = module.vms.vm_fips
}

output "developer_boot_volumes" {
  description = "Boot volume details for snapshot/clone-based VMs"
  value       = module.vms.boot_volumes
}

output "developer_data_volumes" {
  description = "Data volume details attached to VMs"
  value       = module.vms.data_volumes
}

output "developer_data_volumes_by_vm" {
  description = "Data volumes grouped by VM"
  value       = module.vms.data_volumes_by_vm
}

output "developer_vm_details" {
  description = "Detailed VM information including IP, volumes, flavor, and status"
  value       = module.vms.vm_details
}

output "developer_vm_storage_summary" {
  description = "Storage summary per VM"
  value       = module.vms.vm_storage_summary
}

output "developer_network_details" {
  description = "Network infrastructure details"
  value = {
    networks = module.network.network_ids
    subnets  = module.network.subnet_ids
    routers  = module.network.router_ids
    ports    = module.network.port_details
  }
}

############################################################
# 🔥 NEW: Resource Summary (what was imported vs created)
############################################################
output "developer_resource_summary" {
  description = "Summary of imported vs created resources"
  value       = module.network.resource_summary
}

############################################################
# Save outputs and generate AWX inventory
############################################################
resource "null_resource" "save_outputs" {
  depends_on = [
    module.vms,
    module.network
  ]

  triggers = {
    always_run = timestamp()
    vm_fips    = jsonencode(module.vms.vm_fips)
  }

  provisioner "local-exec" {
    command = <<EOT
# Create developer-specific output directory
mkdir -p ${path.module}/../terraform_outputs/developer

# Save Terraform outputs to JSON (developer folder)
terraform output -json > ${path.module}/../terraform_outputs/developer/terraform_output.json

# Generate AWX inventory from Terraform output JSON (developer folder)
python3 ${path.module}/../../scripts/generate_awx_inventory.py \
  ${path.module}/../terraform_outputs/developer/terraform_output.json \
  ${path.module}/../terraform_outputs/developer/awx_inventory.ini \
  developer
EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

############################################################
# Output file locations
############################################################
output "terraform_outputs_file" {
  description = "Path to stored Terraform outputs JSON"
  value       = "${path.module}/../terraform_outputs/developer/terraform_output.json"
  depends_on  = [null_resource.save_outputs]
}

output "awx_inventory_file" {
  description = "Path to generated AWX inventory file"
  value       = "${path.module}/../terraform_outputs/developer/awx_inventory.ini"
  depends_on  = [null_resource.save_outputs]
}
