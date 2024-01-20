packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }

    ansible = {
      version = "1.0.3"
      source  = "github.com/hashicorp/ansible"
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
  vm_name       = "debian-12-template"
  vm_id         = "800"
  iso_file      = "local:iso/debian-12.4.0-amd64-netinst.iso"
  ssh_username  = "root"
  ssh_password  = "debian"
  ssh_timeout   = "4h"
  unmount_iso   = true

  http_directory = "http"
  cores         = 2
  memory        = 4096
 
  disks {
    disk_size = "20G"
    storage_pool = "local-lvm"
    type = "virtio"
  }

  network_adapters {
    model = "virtio"
    bridge = "vmbr1"
  }
  onboot        = true

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
}

build {
  sources = [
    "source.proxmox-iso.example"
  ]

  provisioner "ansible" {
    playbook_file    = "./ansible/debian_config.yml"
    use_proxy        = false
    user             = "debian"
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    extra_arguments  = ["--extra-vars", "ansible_password=debian ansible_become_pass=debian"]
  }

  # Copy default cloud-init config
  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg"
    source      = "http/cloud.cfg"
  }

  # Copy Proxmox cloud-init config
  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg.d/99-pve.cfg"
    source      = "http/99-pve.cfg"
  }

  // run scripts on the VM using scripts from /scripts directory
  provisioner "file" {
    source      = "./scripts"
    destination = "/tmp"
  }
}