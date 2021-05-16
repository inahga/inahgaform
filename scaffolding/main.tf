terraform {
  backend "s3" {
    bucket         = "inahga-tf-state"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "inahga_tf_state_locks"
    encrypt        = true
  }

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 1.0"
    }
  }
}

# provider "vsphere" {
#   user                 = var.vsphere_user
#   password             = var.vsphere_password
#   vsphere_server       = var.vsphere_server
#   allow_unverified_ssl = true
# }

# module "vsphere" {
#   source        = "./vsphere"
#   ssh_keys      = var.ssh_keys
#   inventory_dir = "${path.module}/inventory/vsphere"
# }

provider "aws" {
  region = var.aws_region
  # Use awscli to set the AWS credentials for your session.
}

module "aws" {
  source           = "./aws"
  ssh_keys         = var.ssh_keys
  local_ip_address = var.local_ip_address
}

provider "digitalocean" {
  token = var.digitalocean_apikey
}

module "digitalocean" {
  source   = "./digitalocean"
  ssh_keys = var.ssh_keys
}
