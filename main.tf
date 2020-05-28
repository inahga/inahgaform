#
#

provider "vsphere" {
    user = var.vsphere_user
    password = var.vsphere_password
    vsphere_server = var.vsphere_server
    allow_unverified_ssl = true
}

provider "aws" {
    region = var.aws_region
    # Use awscli to set the AWS credentials for your session.
}
