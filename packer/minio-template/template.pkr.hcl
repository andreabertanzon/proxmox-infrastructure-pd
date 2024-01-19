packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "example" {
  insecure_skip_tls_verify = true
  proxmox_url   = var.proxmox_url
  //username      = var.username
  //password      = var.password
  username      = var.proxmox_token_id
  token         = var.proxmox_api_token_secret
  node          = var.node
  vm_name       = "minio-template"
  vm_id         = "799"
  iso_file      = "local:iso/debian-12.4.0-amd64-netinst.iso"
  ssh_username  = "debian"
  ssh_password  = "debian"
  ssh_timeout   = "4h"
  unmount_iso   = true
  boot_command = [
    "<esc><wait>",
    "/install.amd/vmlinuz auto=true ",
    "initrd=/install.amd/initrd.gz ",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    //"preseed/url=https://drive.google.com/file/d/1tHflQvUJF7glgcgdUVCU_Na8c9VZfmLP/view?usp=sharing ",
    "debian-installer=en_US auto locale=en_US ",
    "console-keymaps-at/keymap=us ",
    "keyboard-configuration/xkb-keymap=us ",
    "netcfg/get_hostname=debian ",
    "netcfg/get_domain=local ",
    "hostname=debian-vm ",
    "fb=false debconf/frontend=noninteractive ",
    "console-setup/ask_detect=false ",
    "initrd=/install.amd/initrd.gz -- <enter>"
  ]
  http_directory = "./"
  cores         = 2
  memory        = 4096
 
  disks {
    disk_size = "50G"
    storage_pool = "local-lvm"
    type = "virtio"
  }

  network_adapters {
    model = "virtio"
    bridge = "vmbr1"
  }
  onboot        = true
}

build {
  sources = [
    "source.proxmox-iso.example"
  ]

  // run scripts on the VM using scripts from /scripts directory
  provisioner "file" {
    source      = "./scripts"
    destination = "/tmp"
  }

  provisioner "file" {
    source = "./extra"
    destination = "/tmp/extra"
  }

  provisioner "shell" {
    inline = [
      "chmod +x /tmp/scripts/*",
      "ls -la /tmp/scripts",
      "ls -la /tmp/extra",
      "sudo cp /tmp/extra/minio /etc/default/minio",
      "sudo /tmp/scripts/1-minio-server.sh",
      "sudo /tmp/scripts/2-minio-user.sh",
      "sudo systemctl start minio.service",
      "sudo systemctl enable minio.service",
    ]
  }
}

