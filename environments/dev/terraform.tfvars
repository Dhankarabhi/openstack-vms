environment          = "dev"
network_name         = "terraform"
external_network_name = "public1"
keypair_name         = "test"
openstack_cloud = "dell"

vms = {
  web1 = {
    name            = "open-vpn"
    flavor          = "m1.medium"
    image           = "ubuntu"
#    security_groups = ["default"]
    security_groups = ["default"]
    keypair         = "test"
    data_volumes     = [
	{
          size = 20
          description = "vpn"
        }
      ]
    assign_fip      = false
    user_data_file  = "../../scripts/user.sh"
  }
  web2 = {
    name            = "wazuh-master-1"
    flavor          = "m1.large"
    image           = "ubuntu"
    security_groups = ["default"]
    assign_fip      = false
    data_volumes     = [
        {
          size = 10
          description = "vpn"
        }
      ]

    keypair         = "test"
    user_data_file  = "../../scripts/user.sh"

  }
#  web3 = {
#    name            = "wazuh-worker-1"
#    flavor          = "m1.large"
#    image           = "ubuntu"
#    security_groups = ["default"]
#    keypair         = "test"   
#    data_volumes     = [
#        {
#          size = 10
#          description = "vpn"
#        }
#      ]

#    user_data_file  = "../../scripts/user.sh"
#    assign_fip      = false
#  }

  web4 = {
    name            = "wazuh-worker-2"
    flavor          = "m1.large"
    image           = "ubuntu"
    security_groups = ["default"]
    keypair         = "test"
    data_volumes     = [
        {
          size = 10
          description = "vpn"
        }
      ]

    assign_fip      = false
    user_data_file  = "../../scripts/user.sh"

  }
#  web5 = {
 #   name            = "wazuh-worker-3"
#    flavor          = "m1.large"
#    image           = "Ubuntu-24.04LTS-Server"
#    security_groups = ["default"]
#    keypair         = "terraform"  
#    volume_size     = 50
#    user_data_file  = "../../scripts/user.sh"
#    assign_fip      = false
 
#  }
#  web6 = {
#    name            = "wazuh-worker-4"
#    flavor          = "m1.large"
#    image           = "Ubuntu-24.04LTS-Server"
#    security_groups = ["default"]
#    keypair         = "terraform"
#    volume_size     = 50
#    assign_fip      = false
#    user_data_file  = "../../scripts/user.sh"
 
#  }
#  web7 = {
#    name            = "docker-center"
#    flavor          = "m1.large"
#    image           = "Ubuntu-24.04LTS-Server"
#    security_groups = ["default"]
#    volume_size     = 10
#    keypair         = "terraform"
#    assign_fip      = false
#    user_data_file  = "../../scripts/user.sh"

# }

# web4 = {
#    name              = "dev-web-4"
#    flavor            = "m1.medium"
#    boot_from_volume  = true                           
#    boot_volume_id    = "f698d3fe-830a-4cee-9911-2208c3444111"          
#    security_groups   = ["default"]
#    keypair           = "openstack"
#    volume_size       = 40
#    assign_fip        = false
#  }
#  web8 = {
#    name             = "wazuh"
#    flavor           = "m1.large"
#    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"      # Boot method: REPLACE THIS
 #   boot_volume_size = 30                            # Boot volume size
 #   data_volumes     = [
 #       {
  #        size = 30
   #       description = "vpn"
   #     }
   #   ]
                            # No data volume
  #  security_groups  = ["default"]
  #  keypair          = "test"
  #  assign_fip       = true
   # user_data_file   = "../../scripts/user.sh"
  #}

# web9 = {
 #   name             = "wazuh-2"
 #   flavor           = "m1.large"
 #   boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"      # Boot method: REPLACE THIS
 #   boot_volume_size = 10                            # Boot volume size
 #   data_volumes     = [
 #       {
 #         size = 10
 #         description = "vpn"
  #      },
  #      {
  #      size        = 10
  #      description = "Wazuh logs"
  #    }
  #    ]
                            # No data volume
  #  security_groups  = ["default"]
  #  keypair          = "test"
  #  assign_fip       = true
 #   user_data_file   = "../../scripts/user.sh"
 # }

#web10 = {
 #   name             = "wazuh-3"
  #  flavor           = "m1.large"
 #   boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"      # Boot method: REPLACE THIS
 #   boot_volume_size = 10                            # Boot volume size
 #   data_volumes     = [
  #      {
  #        size = 10
  #        description = "vpn"
 #       },
 #       {
 #       size        = 30
 #       description = "Wazuh logs"
#      }
#      ]
                            # No data volume
#    security_groups  = ["default"]
#    keypair          = "test"
#    assign_fip       = true
#    user_data_file   = "../../scripts/user.sh"
#  }

# web11 = {
#    name             = "wazuh-4"
#    flavor           = "m1.large"
 #   boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"      # Boot method: REPLACE THIS
 #   boot_volume_size = 30                            # Boot volume size
 #   data_volumes     = [
 #       {
 #         size = 10
 #         description = "vpn"
 #       },
 #       {
 #       size        = 10
 #       description = "Wazuh logs"
 #     }
 #     ]
                            # No data volume
#    security_groups  = ["default"]
#    keypair          = "test"
#    assign_fip       = true
#    user_data_file   = "../../scripts/user.sh"
# }


}

