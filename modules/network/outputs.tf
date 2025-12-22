###############################################
# Network Module Outputs
###############################################

output "network_ids" {
  description = "Map of network names to IDs"
  value = {
    for k, v in openstack_networking_network_v2.networks :
    k => v.id
  }
}

output "network_details" {
  description = "Complete network details"
  value = {
    for k, v in openstack_networking_network_v2.networks :
    k => {
      id          = v.id
      name        = v.name
      description = v.description
      mtu         = v.mtu
    }
  }
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value = {
    for k, v in openstack_networking_subnet_v2.subnets :
    k => v.id
  }
}

output "subnet_details" {
  description = "Complete subnet details"
  value = {
    for k, v in openstack_networking_subnet_v2.subnets :
    k => {
      id          = v.id
      name        = v.name
      network_id  = v.network_id
      cidr        = v.cidr
      gateway_ip  = v.gateway_ip
    }
  }
}

output "router_ids" {
  description = "Map of router names to IDs"
  value = local.router_ids
}

output "router_details" {
  description = "Complete router details"
  value = {
    for k, v in var.routers : k => {
      id                  = local.router_ids[k]
      name                = v.name
      external_network_id = try(v.external_network_id, null)
      mode                = try(v.use_existing, false) ? "existing" : try(v.create, false) ? "new" : "none"
    }
  }
}

output "port_ids" {
  description = "Map of port names to IDs"
  value = {
    for k, v in openstack_networking_port_v2.ports :
    k => v.id
  }
}
