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

variable vsphere_node_count {
  default = 1
}

variable vsphere_node_cpu_count {
  default = 1
}

variable vsphere_node_memory_size {
  default = 1024
}

variable inventory_file {
  default = "../inventory/terraform"
}

variable vsphere_user {}

variable vsphere_password {}

variable vsphere_datacenter {
  default = "Datacenter"
}

variable vsphere_template_folder {
  default = "PackerTemplates"
}

variable vsphere_template {
  default = "Packer_CentOS_8_Latest"
}

variable vsphere_dport_group {
  default = "DPG-TF-30-DMZ"
}

variable vsphere_host {
  default = "esxi2.vsphere.inahga.org"
}

variable vsphere_datastore {
  default = "esxi2-Local"
}

variable vsphere_server {
  default = "vcsa0.vsphere.inahga.org"
}
