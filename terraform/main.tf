module "minio" {
  source = "./modules/minio"

  ssh_user            = var.ssh_user
  ssh_password        = var.ssh_password
  machine_net_ip      = "10.1.1.1"
  machine_net_gateway = "10.1.1.254"
  hostname            = "minio-dev"
  minio_root_user     = var.minio_root_user
  minio_root_password = var.minio_root_password
  proxmox_api_url = var.proxmox_api_url
}