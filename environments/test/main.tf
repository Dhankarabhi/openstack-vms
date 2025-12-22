
###############################################
# PROVIDER
##############################################
###############################################
# NETWORK MODULE
###############################################
module "network" {
  source = "../../modules/network"

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

  ###############################################
  # 🔥 MAP port_keys → port_ids (TEST MODE)
  ###############################################
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

  ###############################################
  # COMMON INPUTS
  ###############################################
  network_name          = var.network_name
  external_network_name = var.external_network_name
  keypair_name          = var.keypair_name
  environment           = var.environment
}
