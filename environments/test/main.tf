
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
  # 🔥 PASS PORT KEYS DIRECTLY (NOT IDs)
  ###############################################
#  vms = var.vms  # Just pass as-is with port_keys

  ###############################################
  # 🔥 PASS PORT ID MAPPING
  ###############################################
  port_id_map = module.network.port_ids

  ###############################################


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
# vms = {
#    for vm_key, vm in var.vms :
#    vm_key => merge(vm, {
      # Map port_keys to actual port IDs from network module
#      port_ids = try(
#        [
#          for idx, port_key in vm.port_keys :
#          idx => module.network.port_ids[port_key]
#        ],
#        null
#      )
#    })
#  }
  ###############################################

  # COMMON INPUTS
  ###############################################
  network_name          = var.network_name
  external_network_name = var.external_network_name
  keypair_name          = var.keypair_name
  environment           = var.environment
}
