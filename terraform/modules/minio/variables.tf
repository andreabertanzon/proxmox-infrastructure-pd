variable "ssh_user" {
  description = "ssh user for proxmox default templates"
  type        = string
}

variable "ssh_password" {
  description = "default ssh password for proxmox default templates"
  type        = string
}

variable "machine_net_ip" {
  description = "value of the machine ip"
  type        = string
}

variable "machine_net_gateway" {
  description = "value of the machine gateway"
  type        = string
}

variable "hostname" {
  description = "value of the machine hostname"
  type        = string
}

variable "minio_root_user" {
  description = "minio initial root user"
  type        = string
}

variable "minio_root_password" {
  description = "minio initial root password"
  type        = string
}

variable "proxmox_api_url" {
  description = "proxmox api url"
  type        = string
}
