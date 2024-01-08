variable "proxmox_url" {
  type = string
  description = "URL of the Proxmox server"
}

variable "username" {
  type = string
  description = "Username for Proxmox"
}

variable "password" {
  type = string
  description = "Password for Proxmox"
}

variable "node" {
  type = string
  description = "Proxmox node name"
}

variable "url" {
  type = string
  description = "Url of Proxmox interface"
  default = "https://your-proxmox-server:8006/api2/json"
}
