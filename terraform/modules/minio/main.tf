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
  name        = var.hostname
  clone       = "ubuntu-server-jammy"
  vmid        = 103
  target_node = "pve" // Replace with your Proxmox node name

  network {
    model  = "virtio"
    bridge = "vmbr1"
  }
  os_type   = "cloud-init"
  ipconfig0 = "ip=${var.machine_net_ip}/24,gw=${var.machine_net_gateway}" // Replace YOUR_GATEWAY_IP with your actual gateway IP

  # VM Advanced General Settings
  onboot = true

  # VM OS Settings

  # VM System Settings
  agent = 1

  # VM CPU Settings
  cores   = 1
  sockets = 1
  cpu     = "host"

  disk {
    storage = "local-lvm"
    type = "virtio"
    size = "50G"
  }

  # VM Memory Settings
  memory = 1024
  connection {
    type     = "ssh"
    user     = var.ssh_user
    password = var.ssh_password
    host     = var.machine_net_ip
  }
  provisioner "remote-exec" {

    inline = [
      "sudo mkdir -p ~/minio/data",
      "sudo docker run -d --restart always -p 9000:9000 -p 9001:9001 --name minio -v ~/minio/data:/data -e 'MINIO_ROOT_USER=${var.minio_root_user}' -e 'MINIO_ROOT_PASSWORD=${var.minio_root_password}' quay.io/minio/minio:RELEASE.2024-01-18T22-51-28Z-cpuv1 server /data --console-address ':9001'"
    ]
  }
}
