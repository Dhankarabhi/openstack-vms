###############################################
# Developer Environment - Hybrid Mode
# Can import test's network + create new subnets
###############################################

###############################################
# NETWORK MODULE (Hybrid Import + Create)
###############################################
module "network" {
  source = "../../modules/network"

  # 🔥 Import existing resources from test env
  use_existing_networks = var.use_existing_networks
  use_existing_subnets  = var.use_existing_subnets
  use_existing_routers  = var.use_existing_routers

  # Create new resources
  networks              = var.networks
  subnets               = var.subnets
  routers               = var.routers
  ports                 = var.ports
  external_network_name = var.external_network_name
}

###############################################
# VM MODULE (PORT-AWARE)
###############################################
module "vms" {
  source = "../../modules/vm"

  # Pass port ID mapping from network module
  port_id_map = module.network.port_ids

  # Map port_keys to actual port IDs
  vms = {
    for vm_key, vm in var.vms :
    vm_key => merge(vm, {
      port_ids = try(
        [
          for port_key in vm.port_keys :
          module.network.port_ids[port_key]
        ],
        null
      )
    })
  }

  # Common inputs
  network_name          = var.network_name
  external_network_name = var.external_network_name
  keypair_name          = var.keypair_name
  environment           = var.environment
}
