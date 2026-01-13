############################################################
# modules/vm/outputs.tf
############################################################

############################################################
# Floating IPs
############################################################
output "vm_fips" {
  description = "Floating IPs of all VMs"
  value       = {
    for k, v in openstack_networking_floatingip_v2.fips :
    k => v.address
  }
}

############################################################
# Boot Volumes
############################################################
output "boot_volumes" {
  description = "Boot volume details for snapshot/clone-based VMs"
  value = {
    for k, v in openstack_blockstorage_volume_v3.boot_volumes :
    k => {
      id   = v.id
      name = v.name
      size = v.size
      type = "boot"
    }
  }
}

############################################################
# Data Volumes (Flat)
############################################################
output "data_volumes" {
  description = "All data volumes created for VMs"
  value = {
    for k, v in openstack_blockstorage_volume_v3.data_volumes :
    k => {
      id     = v.id
      name   = v.name
      size   = v.size
      vm_key = local.data_volumes_flat[k].vm_key
      type   = "data"
    }
  }
}

############################################################
# Data Volumes Grouped by VM
############################################################
output "data_volumes_by_vm" {
  description = "Data volumes grouped per VM"
  value = {
    for k, vm in var.vms :
    k => {
      vm_name      = vm.name
      volume_count = length([
        for vol in values(local.data_volumes_flat) :
        vol if vol.vm_key == k
      ])
      volumes = [
        for vol in values(local.data_volumes_flat) :
        {
          id   = try(openstack_blockstorage_volume_v3.data_volumes[vol.key].id, null)
          name = try(openstack_blockstorage_volume_v3.data_volumes[vol.key].name, null)
          size = vol.size
        }
        if vol.vm_key == k
      ]
    }
  }
}

############################################################
# VM Details
############################################################
output "vm_details" {
  description = "Detailed VM info including IPs and volumes"
  value = {
    for k, v in openstack_compute_instance_v2.vms :
    k => {
      id                = v.id
      name              = v.name
      flavor            = v.flavor_name
      private_ip        = v.network[0].fixed_ip_v4
      fip               = try(openstack_networking_floatingip_v2.fips[k].address, null)
      power_state       = v.power_state
      boot_volume_id    = try(openstack_blockstorage_volume_v3.boot_volumes[k].id, null)
      data_volume_count = length([
        for vol in values(local.data_volumes_flat) :
        vol if vol.vm_key == k
      ])
      data_volumes = [
        for vol in values(local.data_volumes_flat) :
        {
          size = vol.size
        }
        if vol.vm_key == k
      ]
    }
  }
}

############################################################
# VM Storage Summary (🔥 FIXED HERE 🔥)
############################################################
output "vm_storage_summary" {
  description = "Storage summary per VM"
  value = {
    for k, vm in var.vms :
    k => {
      vm_name = vm.name

      boot_volume_size = try(
        openstack_blockstorage_volume_v3.boot_volumes[k].size,
        0
      )

      data_volumes_total_size = try(
        sum([
          for vol in values(local.data_volumes_flat) :
          vol.size if vol.vm_key == k
        ]),
        0
      )

      total_storage = try(
        openstack_blockstorage_volume_v3.boot_volumes[k].size,
        0
      ) + try(
        sum([
          for vol in values(local.data_volumes_flat) :
          vol.size if vol.vm_key == k
        ]),
        0
      )
    }
  }
}
