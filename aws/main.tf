module "iam" {
    source = "./iam"
    ssh_keys = var.ssh_keys
}

module "route53" {
    source = "./route53"
}
