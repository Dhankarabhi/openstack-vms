###############################################
# Environment Configuration
###############################################

environment           = "multinode"
openstack_cloud       = "multinode"
external_network_name = "public1"
keypair_name          = "test"

###############################################
# ✅ EXISTING import
###############################################
use_existing_networks = {
  old_network = {
    name = "test-net"
  }
}

use_existing_routers = {
  old_router = {
    name = "test"
  }
}

use_existing_subnets = {
  old_subnet = {
    name = "test-sub"
  }
}

###############################################
# 🆕 NEW network + router + subnet
###############################################
networks = {
  new_network = {
    name = "new-network"
  }
}

routers = {
  new_router = {
    name = "new-router"
  }
}

subnets = {
  new_subnet = {
    name        = "new-subnet"
    network_key = "new_network"
    cidr        = "10.20.100.0/24"
    gateway_ip  = "10.20.100.1"
    router_key  = "new_router"
  }

  extra_subnet = {
    name        = "extra-subnet"
    network_key = "old_network"
    cidr        = "10.10.200.0/24"
    gateway_ip  = "10.10.200.1"
    router_key  = "old_router"
  }
}

###############################################
# Ports — har VM ka APNA port
###############################################
ports = {

  # old_vm ka port → existing subnet
  old_vm_port = {
    name        = "old-vm-port"
    network_key = "old_network"
    subnet_key  = "old_subnet"
  }

  # new_vm ka port → new subnet
  new_vm_port = {
    name        = "new-vm-port"
    network_key = "new_network"
    subnet_key  = "new_subnet"
  }

  # extra_vm ka port → extra subnet
  extra_vm_port = {
    name        = "extra-vm-port"
    network_key = "old_network"
    subnet_key  = "extra_subnet"
  }

  # multi_vm ke 2 ports — NIC1 existing, NIC2 new
  # ⚠️ Ye dono sirf multi_vm ke liye hain
  multi_vm_port_old = {
    name        = "multi-vm-port-old"
    network_key = "old_network"
    subnet_key  = "old_subnet"
  }

  multi_vm_port_new = {
    name        = "multi-vm-port-new"
    network_key = "new_network"
    subnet_key  = "new_subnet"
  }

}

###############################################
# VMs — har VM ka apna dedicated port
###############################################
vms = {

  # ✅ VM on existing subnet
  old_vm = {
    name            = "vm-existing-subnet"
    flavor          = "m1.small"
    image           = "ubuntu-24"
    security_groups = ["default"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
    port_keys       = ["old_vm_port"]         # sirf iska
  }

  # 🆕 VM on new subnet
  new_vm = {
    name            = "vm-new-subnet"
    flavor          = "m1.small"
    image           = "ubuntu-24"
    security_groups = ["default"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
    port_keys       = ["new_vm_port"]         # sirf iska
  }

  # 🆕 VM on extra subnet
  extra_vm = {
    name            = "vm-extra-subnet"
    flavor          = "m1.small"
    image           = "ubuntu-24"
    security_groups = ["default"]
    keypair         = "test"
    assign_fip      = false
    user_data_file  = "../../scripts/user.sh"
    port_keys       = ["extra_vm_port"]       # sirf iska
  }

  # 🔥 Multi-NIC VM — 2 dedicated ports
  multi_vm = {
    name            = "vm-multi-nic"
    flavor          = "m1.small"
    image           = "ubuntu-24"
    security_groups = ["default"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
    port_keys       = ["multi_vm_port_old", "multi_vm_port_new"]  # sirf iske
  }

}

###############################################
# Fallback + empty blocks
###############################################
network_name = "my-network"