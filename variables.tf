#
#

variable vsphere_user {}
variable vsphere_password {}

variable vsphere_server {
    default = "vcsa0.vsphere.inahga.org"
}

variable aws_s3_tf_state {
    default = "inahga-tf-state"
}

variable aws_dynamodb_tf_state_locks {
    default = "inahga_tf_state_locks"
}

variable aws_region {
    default = "us-west-2"
}

