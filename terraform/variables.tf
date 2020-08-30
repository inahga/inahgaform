variable aws_ssh_key_name {
  default = "aghani"
}

variable aws_instance_type {
  default = "t2.micro"
}

variable aws_region {
  default = "us-west-2"
}

variable aws_vpc_cidr_block {
  default = "10.10.0.0/27"
}

variable aws_vpc_subnets {
  default = [
    "10.10.0.0/28",
    "10.10.0.16/28"
  ]
}

variable aws_hosted_zone_name {
  default = "inahga.org."
}

variable aws_ingress_service_allowlist {
  default = {
    10 = {
      port     = 22
      protocol = "tcp"
    }
    20 = {
      port     = 80
      protocol = "tcp"
    }
    30 = {
      port     = 443
      protocol = "tcp"
    }
    40 = {
      port     = 2222
      protocol = "tcp"
    }
  }
}

variable aws_ssh_port {
  default = 2222
}

variable aws_node_count {
  default = 1
}

variable inventory_file {
  default = "../inventory/terraform"
}

variable cnames {
  default = [
    "gitlab.inahga.org"
  ]
}
