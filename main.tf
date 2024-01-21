terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.14" // Specify the desired version
    }
  }
}

provider "proxmox" {
  pm_api_url = var.proxmox_api_url
}

resource "proxmox_vm_qemu" "minio-dev" {
  name        = "minio-dev"
  clone       = "ubuntu-server-jammy"
  vmid        = 103
  target_node = "pve" // Replace with your Proxmox node name

  network {
    model  = "virtio"
    bridge = "vmbr1"
  }
  os_type   = "cloud-init"
  ipconfig0 = "ip=10.1.1.1/24,gw=10.1.1.255" // Replace YOUR_GATEWAY_IP with your actual gateway IP

  # VM Advanced General Settings
  onboot = true

  # VM OS Settings

  # VM System Settings
  agent = 1

  # VM CPU Settings
  cores   = 1
  sockets = 1
  cpu     = "host"

  # VM Memory Settings
  memory = 1024
  connection {
    type     = "ssh"
    user     = var.ssh_user
    password = var.ssh_password
    host     = "10.1.1.1"
  }
  provisioner "remote-exec" {
    
    inline = [
      "ip a"
    ]
  }

}

// Optionally, you can add Terraform outputs to retrieve the IP address
output "vm_ip" {
  value = proxmox_vm_qemu.minio-dev.ipconfig0
}
