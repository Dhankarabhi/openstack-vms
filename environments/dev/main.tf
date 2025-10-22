##############################################
# Dev environment — call VM module
##############################################

module "vms" {
  source               = "../../modules/vm"
  environment          = var.environment
  network_name         = var.network_name
  external_network_name = var.external_network_name
  keypair_name         = var.keypair_name
  vms                  = var.vms
}

