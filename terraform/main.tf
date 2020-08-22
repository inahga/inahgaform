terraform {
  backend "s3" {
    bucket         = "inahga-tf-state"
    key            = "cloud-proxy.tfstate"
    region         = "us-west-2"
    dynamodb_table = "inahga_tf_state_locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-west-2"
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}
