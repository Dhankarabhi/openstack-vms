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
# 🔥 IMPORT EXISTING NETWORKS (from other envs)
###############################################
data "openstack_networking_network_v2" "imported" {
  for_each = var.use_existing_networks
  name     = each.value.name
}

###############################################
# 🔥 IMPORT EXISTING SUBNETS (from other envs)
###############################################
data "openstack_networking_subnet_v2" "imported" {
  for_each = var.use_existing_subnets
  name     = each.value.name
}

###############################################
# 🔥 IMPORT EXISTING ROUTERS (from other envs)
###############################################
data "openstack_networking_router_v2" "imported_routers" {
  for_each = var.use_existing_routers
  name     = each.value.name
}

###############################################
# Create NEW Networks
###############################################
resource "openstack_networking_network_v2" "networks" {
  for_each = var.networks

  name           = each.value.name
  admin_state_up = try(each.value.admin_state_up, true)
  description    = try(each.value.description, null)
}

###############################################
# 🔥 MERGE: Created + Imported Networks
###############################################
locals {
  all_network_ids = merge(
    { for k, v in openstack_networking_network_v2.networks : k => v.id },
    { for k, v in data.openstack_networking_network_v2.imported : k => v.id }
  )
}

###############################################
# Create NEW Subnets
###############################################
resource "openstack_networking_subnet_v2" "subnets" {
  for_each = var.subnets

  name        = each.value.name
  network_id  = local.all_network_ids[each.value.network_key]  # ✅ Uses merged map
  cidr        = each.value.cidr
  ip_version  = try(each.value.ip_version, 4)

  enable_dhcp = try(each.value.enable_dhcp, true)

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
# 🔥 MERGE: Created + Imported Subnets
###############################################
locals {
  all_subnet_ids = merge(
    { for k, v in openstack_networking_subnet_v2.subnets : k => v.id },
    { for k, v in data.openstack_networking_subnet_v2.imported : k => v.id }
  )
}

###############################################
# Routers – CREATE NEW
###############################################
resource "openstack_networking_router_v2" "routers" {
  for_each = {
    for k, v in var.routers :
    k => v
    if try(v.create, false) == true && try(v.use_existing, false) == false
  }

  name           = each.value.name
  admin_state_up = true

  external_network_id = data.openstack_networking_network_v2.external.id
}

###############################################
# Routers – USE EXISTING (same env)
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
# 🔥 MERGE: All Router IDs
###############################################
locals {
  all_router_ids = merge(
    { for k, r in openstack_networking_router_v2.routers : k => r.id },
    { for k, r in data.openstack_networking_router_v2.existing : k => r.id },
    { for k, r in data.openstack_networking_router_v2.imported_routers : k => r.id }
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

  router_id = local.all_router_ids[each.value.router_key]  # ✅ Uses merged map
  subnet_id = openstack_networking_subnet_v2.subnets[each.key].id
}

###############################################
# Create Neutron Ports
###############################################
resource "openstack_networking_port_v2" "ports" {
  for_each = var.ports

  name       = each.value.name
  network_id = local.all_network_ids[each.value.network_key]  # ✅ Uses merged map

  admin_state_up = true

  fixed_ip {
    subnet_id  = local.all_subnet_ids[each.value.subnet_key]  # ✅ Uses merged map
    ip_address = try(each.value.fixed_ip, null)
  }

  security_group_ids = try(each.value.security_groups, [])
}
