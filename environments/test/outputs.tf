############################################################
# environments/test/outputs.tf
############################################################

############################################################
# Root-level outputs (from module)
############################################################
output "test_vm_fips" {
  description = "Floating IPs of all VMs"
  value       = module.vms.vm_fips
}

output "test_boot_volumes" {
  description = "Boot volume details for snapshot/clone-based VMs"
  value       = module.vms.boot_volumes
}

output "test_data_volumes" {
  description = "Data volume details attached to VMs"
  value       = module.vms.data_volumes
}

output "test_data_volumes_by_vm" {
  description = "Data volumes grouped by VM"
  value       = module.vms.data_volumes_by_vm
}

output "test_vm_details" {
  description = "Detailed VM information including IP, volumes, flavor, and status"
  value       = module.vms.vm_details
}

output "test_vm_storage_summary" {
  description = "Storage summary per VM"
  value       = module.vms.vm_storage_summary
}

output "test_network_details" {
  description = "Network infrastructure details"
  value = {
    networks = module.network.network_ids
    subnets  = module.network.subnet_ids
    routers  = module.network.router_ids
    ports    = module.network.port_details
  }
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
# Create test-specific output directory
mkdir -p ${path.module}/../terraform_outputs/test

# Save Terraform outputs to JSON (test folder)
terraform output -json > ${path.module}/../terraform_outputs/test/terraform_output.json

# Generate AWX inventory from Terraform output JSON (test folder)
python3 ${path.module}/../../scripts/generate_awx_inventory.py \
  ${path.module}/../terraform_outputs/test/terraform_output.json \
  ${path.module}/../terraform_outputs/test/awx_inventory.ini \
  test
EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

############################################################
# Output file locations
############################################################
output "terraform_outputs_file" {
  description = "Path to stored Terraform outputs JSON"
  value       = "${path.module}/../terraform_outputs/test/terraform_output.json"
  depends_on  = [null_resource.save_outputs]
}

output "awx_inventory_file" {
  description = "Path to generated AWX inventory file"
  value       = "${path.module}/../terraform_outputs/test/awx_inventory.ini"
  depends_on  = [null_resource.save_outputs]
}
