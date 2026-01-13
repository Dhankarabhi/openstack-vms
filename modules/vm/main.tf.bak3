terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 1.52.1"
    }
  }
}

###############################################
# DATA SOURCES
###############################################

# 🔹 EXISTING NETWORK (DEV / LEGACY MODE)
data "openstack_networking_network_v2" "existing" {
  count = var.use_existing_network ? 1 : 0
  name = var.network_name
}

# 🔹 EXTERNAL NETWORK (FLOATING IP)
data "openstack_networking_network_v2" "external" {
  name = var.external_network_name
}

###############################################
# BOOT VOLUMES (SNAPSHOT / CLONE)
###############################################
resource "openstack_blockstorage_volume_v3" "boot_volumes" {
  for_each = {
    for k, vm in var.vms : k => vm
    if try(vm.boot_snapshot_id, null) != null || try(vm.source_volume_id, null) != null
  }

  name          = "${each.value.name}-boot"
  size          = lookup(each.value, "boot_volume_size", 50)
  snapshot_id   = lookup(each.value, "boot_snapshot_id", null)
  source_vol_id = lookup(each.value, "source_volume_id", null)
  volume_type   = lookup(each.value, "volume_type", null)

  enable_online_resize = true
}

###############################################
# DATA VOLUMES (FLATTENED)
###############################################
locals {
  data_volumes_flat = merge([
    for vm_key, vm in var.vms : {
      for idx, vol in try(vm.data_volumes, []) :
      "${vm_key}-data-${idx}" => {
        vm_key      = vm_key
        vm_name     = vm.name
        size        = vol.size
        description = try(vol.description, "data-${idx}")
        volume_type = try(vol.volume_type, null)
        device      = try(vol.device, null)
        enable_online_resize = true
      }
    }
  ]...)
}

resource "openstack_blockstorage_volume_v3" "data_volumes" {
  for_each = local.data_volumes_flat

  name        = "${each.value.vm_name}-data-${each.key}"
  size        = each.value.size
  description = each.value.description
  volume_type = each.value.volume_type

  enable_online_resize = true
}

###############################################
# COMPUTE INSTANCES (DUAL MODE)
###############################################
resource "openstack_compute_instance_v2" "vms" {
  for_each = var.vms

  name            = each.value.name
  flavor_name     = each.value.flavor
  key_pair        = coalesce(each.value.keypair, var.keypair_name)
  security_groups = each.value.security_groups

  # Image only if NOT booting from volume
  image_name = (
    try(each.value.boot_volume_id, null) != null ||
    try(each.value.boot_snapshot_id, null) != null ||
    try(each.value.source_volume_id, null) != null
  ) ? null : each.value.image

  ###############################################
  # 🔥 NETWORK ATTACHMENT (FINAL FIX)
  ###############################################

  # 🔹 PORT MODE (TEST / PROD)
#  dynamic "network" {
#    for_each = try(each.value.port_ids, null) != null ? each.value.port_ids : []
#    content {
#      port = network.value
#    }
#  }

  # 🔹 LEGACY MODE (DEV)
#  dynamic "network" {
#    for_each = try(each.value.port_ids, null) == null ? [1] : []
#    content {
#      uuid = data.openstack_networking_network_v2.existing.id
#    }
#  }

###############################################
# NETWORK ATTACHMENT (FINAL SAFE LOGIC)
###############################################

# 🔹 PORT MODE (TEST / PROD)
dynamic "network" {
  for_each = try(each.value.port_ids, null) != null ? each.value.port_ids : []
  content {
    port = network.value
  }
}

# 🔹 EXISTING NETWORK MODE (DEV ONLY)
dynamic "network" {
  for_each = (
    var.use_existing_network == true &&
    try(each.value.port_ids, null) == null
  ) ? [1] : []

  content {
    uuid = data.openstack_networking_network_v2.existing[0].id
  }
}


  ###############################################
  # USER DATA
  ###############################################
  user_data = try(file(each.value.user_data_file), null)

  metadata = {
    environment = var.environment
  }

  ###############################################
  # BOOT FROM EXISTING VOLUME
  ###############################################
  dynamic "block_device" {
    for_each = try(each.value.boot_volume_id, null) != null ? [1] : []
    content {
      uuid                  = each.value.boot_volume_id
      source_type           = "volume"
      destination_type      = "volume"
      boot_index            = 0
      delete_on_termination = false
    }
  }

  ###############################################
  # BOOT FROM SNAPSHOT / CLONE
  ###############################################
  dynamic "block_device" {
    for_each = (
      try(each.value.boot_snapshot_id, null) != null ||
      try(each.value.source_volume_id, null) != null
    ) ? [1] : []
    content {
      uuid                  = openstack_blockstorage_volume_v3.boot_volumes[each.key].id
      source_type           = "volume"
      destination_type      = "volume"
      boot_index            = 0
      delete_on_termination = lookup(each.value, "delete_boot_volume_on_termination", false)
    }
  }

  lifecycle {
    ignore_changes = [
      user_data,
      image_name,
      image_id,
    ]
  }

  depends_on = [
    openstack_blockstorage_volume_v3.boot_volumes
  ]
}

###############################################
# ATTACH DATA VOLUMES
###############################################
resource "openstack_compute_volume_attach_v2" "attach_data" {
  for_each = local.data_volumes_flat

  instance_id = openstack_compute_instance_v2.vms[each.value.vm_key].id
  volume_id   = openstack_blockstorage_volume_v3.data_volumes[each.key].id
  device      = each.value.device
}

###############################################
# FLOATING IPs
###############################################
resource "openstack_networking_floatingip_v2" "fips" {
  for_each = {
    for k, vm in var.vms : k => vm
    if try(vm.assign_fip, false)
  }

  pool = data.openstack_networking_network_v2.external.name
}

resource "openstack_compute_floatingip_associate_v2" "fip_assoc" {
  for_each = openstack_networking_floatingip_v2.fips

  floating_ip = each.value.address
  instance_id = openstack_compute_instance_v2.vms[each.key].id
}
