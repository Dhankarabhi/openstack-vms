terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 1.52.1"
    }
  }
}

###############################################
# External Provider Network (RBAC SAFE)
###############################################
data "openstack_networking_network_v2" "external" {
  name = var.external_network_name
}

###############################################
# Create Networks
###############################################
resource "openstack_networking_network_v2" "networks" {
  for_each = var.networks

  name           = each.value.name
  admin_state_up = try(each.value.admin_state_up, true)
  description    = try(each.value.description, null)
}

###############################################
# Create Subnets (FIXED: gateway_ip vs no_gateway)
###############################################
resource "openstack_networking_subnet_v2" "subnets" {
  for_each = var.subnets

  name        = each.value.name
  network_id = openstack_networking_network_v2.networks[each.value.network_key].id
  cidr        = each.value.cidr
  ip_version  = try(each.value.ip_version, 4)

  enable_dhcp = try(each.value.enable_dhcp, true)

  # 🔥 IMPORTANT FIX: only ONE of these is ever set
  gateway_ip = (
    try(each.value.no_gateway, false) == true
    ? null
    : try(each.value.gateway_ip, null)
  )

  no_gateway = (
    try(each.value.no_gateway, false) == true
    ? true
    : null
  )

  dns_nameservers = try(each.value.dns_nameservers, [])
}

###############################################
# Routers – CREATE (DOCUMENT / HORIZON STYLE)
###############################################
resource "openstack_networking_router_v2" "routers" {
  for_each = {
    for k, v in var.routers :
    k => v
    if try(v.create, false) == true && try(v.use_existing, false) == false
  }

  name           = each.value.name
  admin_state_up = true

  # 🔥 External gateway resolved via DATA SOURCE
  external_network_id = data.openstack_networking_network_v2.external.id
}

###############################################
# Routers – USE EXISTING
###############################################
data "openstack_networking_router_v2" "existing" {
  for_each = {
    for k, v in var.routers :
    k => v
    if try(v.use_existing, false) == true
  }

  name = each.value.name
}

###############################################
# Resolve Router IDs (SAFE)
###############################################
locals {
  router_ids = merge(
    { for k, r in openstack_networking_router_v2.routers : k => r.id },
    { for k, r in data.openstack_networking_router_v2.existing : k => r.id }
  )
}

###############################################
# Attach Subnets to Routers
###############################################
resource "openstack_networking_router_interface_v2" "router_interfaces" {
  for_each = {
    for k, v in var.subnets :
    k => v
    if try(v.router_key, null) != null
  }

  router_id = local.router_ids[each.value.router_key]
  subnet_id = openstack_networking_subnet_v2.subnets[each.key].id
}

###############################################
# Ports (Optional)
###############################################
#resource "openstack_networking_port_v2" "ports" {
#  for_each = var.ports

#  name       = each.value.name
#  network_id = openstack_networking_network_v2.networks[each.value.network_key].id
#}
###############################################
# Create Neutron Ports (SUBNET AWARE)
###############################################
###############################################
# Create Neutron Ports (FINAL FIXED VERSION)
###############################################
resource "openstack_networking_port_v2" "ports" {
  for_each = var.ports

  name       = each.value.name
  network_id = openstack_networking_network_v2.networks[each.value.network_key].id

  admin_state_up = true

  # 🔥 subnet-bound fixed IP ONLY when subnet_key is provided
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.subnets[each.value.subnet_key].id
    ip_address = try(each.value.fixed_ip, null)
  }

  security_group_ids = try(each.value.security_groups, [])
}

