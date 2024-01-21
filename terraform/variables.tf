variable "proxmox_api_url" {
    type = string
    description = "api url for proxmox"
}

variable "ssh_user" {
    type = string
    description = "ssh user for proxmox default templates"
}

variable "ssh_password" {
    type = string
    description = "default ssh password for proxmox default templates"
}

variable "minio_root_user" {
    type = string
    description = "minio initial root user"
}

variable "minio_root_password" {
    type = string
    description = "minio initial root password"
}