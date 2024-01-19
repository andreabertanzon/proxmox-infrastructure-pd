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