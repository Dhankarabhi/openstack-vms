###############################################
# modules/network/outputs.tf
###############################################

output "network_ids" {
  description = "Map of network keys to network IDs"
  value = {
    for k, v in openstack_networking_network_v2.networks : k => v.id
  }
}

output "subnet_ids" {
  description = "Map of subnet keys to subnet IDs"
  value = {
    for k, v in openstack_networking_subnet_v2.subnets : k => v.id
  }
}

output "router_ids" {
  description = "Map of router keys to router IDs"
  value = local.router_ids
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
