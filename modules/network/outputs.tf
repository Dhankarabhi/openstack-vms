###############################################
# modules/network/outputs.tf (ENHANCED)
###############################################

output "network_ids" {
  description = "Map of network keys to network IDs (created + imported)"
  value       = local.all_network_ids
}

output "subnet_ids" {
  description = "Map of subnet keys to subnet IDs (created + imported)"
  value       = local.all_subnet_ids
}

output "router_ids" {
  description = "Map of router keys to router IDs (created + imported)"
  value       = local.all_router_ids
}

output "port_ids" {
  description = "Map of port keys to port IDs"
  value = {
    for k, v in openstack_networking_port_v2.ports : k => v.id
  }
}

output "port_details" {
  description = "Detailed information about all ports"
  value = {
    for k, v in openstack_networking_port_v2.ports : k => {
      id         = v.id
      name       = v.name
      network_id = v.network_id
      fixed_ips  = v.all_fixed_ips
      mac        = v.mac_address
    }
  }
}

###############################################
# 🔥 NEW: Show what was imported vs created
###############################################
output "resource_summary" {
  description = "Summary of imported vs created resources"
  value = {
    networks = {
      imported = keys(var.use_existing_networks)
      created  = keys(var.networks)
      total    = keys(local.all_network_ids)
    }
    subnets = {
      imported = keys(var.use_existing_subnets)
      created  = keys(var.subnets)
      total    = keys(local.all_subnet_ids)
    }
    routers = {
      imported = keys(var.use_existing_routers)
      created  = [for k, v in var.routers : k if try(v.create, false)]
      existing = [for k, v in var.routers : k if try(v.use_existing, false)]
      total    = keys(local.all_router_ids)
    }
    ports = {
      created = keys(var.ports)
    }
  }
}
