source "proxmox" "example" {
  proxmox_url = var.url
  username    = var.proxmox_url
  password    = var.username
  node        = var.password
  vm_id       = "100"
  iso_file    = "local:iso/debian-xx.iso"
  ssh_username = "debian"
  ssh_password = "debian"
  ssh_timeout  = "4h"
  unmount_iso  = true
  boot_command = [
    "<tab> text preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <enter>"
  ]
  cores = 2
  memory = 4096
}

build {
  sources = [
    "source.proxmox.example"
  ]

  provisioner "shell" {
    script = "setup.sh"
  }
}
