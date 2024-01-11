packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_url" {
  type    = string
  default = "https://your-proxmox-server:8006/api2/json"
}

variable "username" {
  type    = string
  default = "root@pam"
}


variable "proxmox_api_token_secret" {
  type    = string
  default = "https://your-proxmox-server:8006/api2/json"
}

variable "proxmox_token_id" {
  type    = string
  default = "https://your-proxmox-server:8006/api2/json"
}

variable "password" {
  type    = string
  default = "yourpassword"
}

variable "node" {
  type    = string
  default = "pve"
}

source "proxmox-iso" "example" {
  insecure_skip_tls_verify = true
  proxmox_url   = var.proxmox_url
  //username      = var.username
  //password      = var.password
  username      = var.proxmox_token_id
  token         = var.proxmox_api_token_secret
  node          = var.node
  vm_id         = "800"
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
    disk_size = "20G"
    storage_pool = "local-lvm"
    type = "virtio"
  }

  network_adapters {
    model = "virtio"
    bridge = "vmbr0"
  }
  onboot        = true
}

build {
  sources = [
    "source.proxmox-iso.example"
  ]
}

