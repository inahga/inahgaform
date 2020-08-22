terraform {
  backend "s3" {
    bucket         = "inahga-tf-state"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "inahga_tf_state_locks"
    encrypt        = true
  }
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

provider "aws" {
  region = var.aws_region
  # Use awscli to set the AWS credentials for your session.
}

module "vsphere" {
  source        = "./vsphere"
  ssh_keys      = var.ssh_keys
  inventory_dir = "${path.module}/inventory/vsphere"
}

module "aws" {
  source   = "./aws"
  ssh_keys = var.ssh_keys
}
