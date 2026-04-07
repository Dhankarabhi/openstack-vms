# =========================
# Environment Configuration
# =========================
environment             = "dev"
network_name            = "terraform"
external_network_name   = "public1"
keypair_name            = "test"
openstack_cloud         = "dell"


# =========================
# Virtual Machines
# =========================
vms = {

  # -------------------------
  # (Boot from Snapshot)
  # -------------------------
  web1 = {
    name             = "jenkins-controller"
    flavor           = "m1.large"

    # Boot from snapshot
    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"
    boot_volume_size = 50

    # Data volumes
    #data_volumes = [
     # {
      #  size        = 30
       # description = "vpn"
      #}
    #]

    security_groups = ["default", "wazuh"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
  }
  web2 = {
    name             = "sonar"
    flavor           = "m1.large"

    # Boot from snapshot
    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"
    boot_volume_size = 50
    security_groups = ["default", "wazuh"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
  }

 web1-1 = {
    name             = "jenkins-agent"
    flavor           = "m1.large"

    # Boot from snapshot
    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"
    boot_volume_size = 50
    security_groups = ["default", "wazuh"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
  }


 web3 = {
    name             = "harbor-master"
    flavor           = "m1.large"
   # Boot from snapshot
    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"
    boot_volume_size = 50
    security_groups = ["default", "wazuh", "k8s"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
  }
 web4 = {
    name             = "harbor-worker-1"
    flavor           = "m1.large"

    # Boot from snapshot
    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"
    boot_volume_size = 50
   # Data volumes
    data_volumes = [
      {
        size        = 200
        description = "vpn"
      }
    ]
    security_groups = ["default", "wazuh", "k8s"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
  }
 web5 = {
    name             = "harbor-worker-2"
    flavor           = "m1.large"

    # Boot from snapshot
    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"
    boot_volume_size = 50
   # Data volumes
    data_volumes = [
      {
        size        = 200
        description = "vpn"
      }
    ]
    security_groups = ["default", "wazuh", "k8s"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
  }
 web5-2 = {
    name             = "harbor-worker-3"
    flavor           = "m1.large"

    # Boot from snapshot
    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"
    boot_volume_size = 50
   # Data volumes
    data_volumes = [
      {
        size        = 200
        description = "vpn"
      }
    ]
    security_groups = ["default", "wazuh", "k8s"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
  }

 web5-1 = {
    name             = "harbor-lb"
    flavor           = "m1.large"

    # Boot from snapshot
    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"
    boot_volume_size = 50
    security_groups = ["default", "wazuh", "k8s"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
  }

 web6 = {
    name             = "k8s-master"
    flavor           = "m1.large"

    # Boot from snapshot
    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"
    boot_volume_size = 50
    security_groups = ["default", "wazuh", "k8s"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
  }
 web7 = {
    name             = "k8s-worker"
    flavor           = "m1.large"

    # Boot from snapshot
    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"
    boot_volume_size = 50
    security_groups = ["default", "wazuh", "k8s"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
  }
 web8 = {
    name             = "argo-cd"
    flavor           = "m1.large"

    # Boot from snapshot
    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"
    boot_volume_size = 50
    security_groups = ["default", "wazuh", "k8s"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
  }
 web9 = {
    name             = "minio-master"
    flavor           = "m1.large"

    # Boot from snapshot
    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"
    boot_volume_size = 50
    security_groups = ["default", "wazuh", "k8s"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
  }
 web10 = {
    name             = "minio-worker"
    flavor           = "m1.large"

    # Boot from snapshot
    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"
    boot_volume_size = 50
    data_volumes = [
      {
        size        = 70
        description = "vpn"
      },
      {
        size        = 70
        description = "vpn"
      }

    ]
    security_groups = ["default", "wazuh", "k8s"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
  }
 web11 = {
    name             = "minio-worker-2"
    flavor           = "m1.large"

    # Boot from snapshot
    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"
    boot_volume_size = 50
    data_volumes = [
      {
        size        = 70
        description = "vpn"
      },
      {
        size        = 70
        description = "vpn"
      }

    ]
    security_groups = ["default", "wazuh", "k8s"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
  }
 web12 = {
    name             = "minio-worker-3"
    flavor           = "m1.large"

    # Boot from snapshot
    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"
    boot_volume_size = 50
    data_volumes = [
      {
        size        = 70
        description = "vpn"
      },
      {
        size        = 70
        description = "vpn"
      }

    ]
    security_groups = ["default", "wazuh", "k8s"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
  }
 web13 = {
    name             = "minio-worker-4"
    flavor           = "m1.large"

    # Boot from snapshot
    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"
    boot_volume_size = 50
    data_volumes = [
      {
        size        = 70
        description = "vpn"
      },
      {
        size        = 70
        description = "vpn"
      }

    ]
    security_groups = ["default", "wazuh", "k8s"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
  }

  # =========================================================
  # COMMENTED BLOCKS – KEPT FOR FUTURE USE (UNCHANGED LOGIC)
  # =========================================================

  # web4 = {
  #   name             = "dev-web-4"
  #   flavor           = "m1.medium"
  #   boot_from_volume = true
  #   boot_volume_id   = "f698d3fe-830a-4cee-9911-2208c3444111"
  #   security_groups  = ["default"]
  #   keypair          = "openstack"
  #   volume_size      = 40
  #   assign_fip       = false
  # }

  # web1 = {
  #   name            = "open-vpn"
  #   flavor          = "m1.medium"
  #   image           = "ubuntu"
  #   security_groups = ["default"]
  #   keypair         = "test"
  #
  #   data_volumes = [
  #     {
  #       size        = 20
  #       description = "vpn"
  #     }
  #   ]
  #
  #   assign_fip     = true
  #   user_data_file = "../../scripts/user.sh"
  # }

}
