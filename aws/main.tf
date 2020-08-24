module "iam" {
  source   = "./iam"
  ssh_keys = var.ssh_keys
}

module "route53" {
  source           = "./route53"
  local_ip_address = var.local_ip_address
}
