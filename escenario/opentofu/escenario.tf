##############################################
# escenario.tf — Escenario proxy + backend
##############################################

locals {

  ##############################################
  # Redes a crear
  ##############################################

  networks = {
    red-externa = {
      name      = "red-externa"
      mode      = "nat"
      domain    = "externa.com"
      addresses = ["192.168.200.0/24"]
      bridge    = "br-ex"
      dhcp      = true
      dns       = true
      autostart = true
    }

    red-empresa1 = {
      name      = "red-empresa1"
      mode      = "none" # sin conectividad
      bridge    = "br-empresa1"
      autostart = true
    }

    red-empresa2 = {
      name      = "red-empresa2"
      mode      = "none" # sin conectividad
      bridge    = "br-empresa2"
      autostart = true
    }

    red-internet = {
      name      = "red-internet"
      mode      = "none" # sin conectividad
      bridge    = "br-internet"
      autostart = true
    }
  }

  ##############################################
  # Máquinas virtuales a crear
  ##############################################

  servers = {
    empresa1 = {
      name       = "empresa1"
      memory     = 1024
      vcpu       = 1
      base_image = "debian13-base.qcow2"

      networks = [
        { network_name = "red-externa", wait_for_lease = true },
        { network_name = "red-empresa1" },
        { network_name = "red-internet" }
      ]

      user_data      = "${path.module}/cloud-init/empresa1/user-data.yaml"
      network_config = "${path.module}/cloud-init/empresa1/network-config.yaml"
    }

    empresa2 = {
      name       = "empresa2"
      memory     = 1024
      vcpu       = 1
      base_image = "debian13-base.qcow2"

      networks = [
        { network_name = "red-externa", wait_for_lease = true },
        { network_name = "red-empresa2" },
        { network_name = "red-internet" }
      ]

      user_data      = "${path.module}/cloud-init/empresa2/user-data.yaml"
      network_config = "${path.module}/cloud-init/empresa2/network-config.yaml"
    }

    cliente1 = {
      name       = "cliente1"
      memory     = 1024
      vcpu       = 1
      base_image = "debian13-base.qcow2"

      networks = [
        { network_name = "red-externa", wait_for_lease = true },
        { network_name = "red-empresa1" }
      ]

      user_data      = "${path.module}/cloud-init/cliente1/user-data.yaml"
      network_config = "${path.module}/cloud-init/cliente1/network-config.yaml"
    }

    cliente2 = {
      name       = "cliente2"
      memory     = 1024
      vcpu       = 1
      base_image = "debian13-base.qcow2"

      networks = [
        { network_name = "red-externa", wait_for_lease = true },
        { network_name = "red-empresa2" }
      ]

      user_data      = "${path.module}/cloud-init/cliente2/user-data.yaml"
      network_config = "${path.module}/cloud-init/cliente2/network-config.yaml"
    }
  }
}
