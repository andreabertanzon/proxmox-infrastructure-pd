terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.14" // Specify the desired version
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://192.168.1.248:8006/api2/json"
}

resource "proxmox_vm_qemu" "minio_dev" {
  name        = "minio-dev"
  clone       = "minio-template"
  vmid        = 103
  target_node = "pve" // Replace with your Proxmox node name

  network {
    model  = "virtio"
    bridge = "vmbr1"
  }

  ipconfig0 = "ip=10.1.1.1/24,gw=10.1.1.1/24" // Replace YOUR_GATEWAY_IP with your actual gateway IP

  // Additional configuration options can be added as needed
}

// Optionally, you can add Terraform outputs to retrieve the IP address
output "vm_ip" {
  value = proxmox_vm_qemu.minio-dev.ipconfig0
}
