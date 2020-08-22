# Creates a VPC and divides it into two subnets

resource "aws_vpc" "cpxy_vpc" {
  cidr_block           = var.aws_vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "cpxy_vpc"
  }
}

resource "aws_subnet" "cpxy_subnets" {
  count                   = length(var.aws_vpc_subnets)
  vpc_id                  = aws_vpc.cpxy_vpc.id
  cidr_block              = var.aws_vpc_subnets[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "cpxy_subnet_${count.index}"
  }
}

resource "aws_internet_gateway" "cpxy_gateway" {
  vpc_id = aws_vpc.cpxy_vpc.id
  tags = {
    Name = "cpxy_gateway"
  }
}

resource "aws_route_table" "cpxy_default_route_table" {
  vpc_id = aws_vpc.cpxy_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cpxy_gateway.id
  }
  tags = {
    Name = "cpxy_default_route_table"
  }
}

resource "aws_main_route_table_association" "cpxy_default_route_table_association" {
  vpc_id         = aws_vpc.cpxy_vpc.id
  route_table_id = aws_route_table.cpxy_default_route_table.id
}

resource "aws_default_network_acl" "cpxy_default_nacl" {
  default_network_acl_id = aws_vpc.cpxy_vpc.default_network_acl_id

  dynamic "ingress" {
    for_each = var.aws_ingress_service_allowlist
    content {
      protocol   = ingress.value["protocol"]
      rule_no    = ingress.key
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = ingress.value["port"]
      to_port    = ingress.value["port"]
    }
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "cpxy_default_nacl"
  }

  # See https://github.com/terraform-providers/terraform-provider-aws/issues/346
  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

resource "aws_default_security_group" "cpxy_default_sg" {
  vpc_id = aws_vpc.cpxy_vpc.id

  dynamic "ingress" {
    for_each = var.aws_ingress_service_allowlist
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cpxy_default_sg"
  }
}

data "aws_ami" "fedora" {
  owners = ["125523088429"]
  filter {
    name = "image-id"

    # Fedora 32
    values = ["ami-020405ee5d5747724"]
  }
}

resource "aws_instance" "cpxy_nodes" {
  count         = var.aws_node_count
  ami           = data.aws_ami.fedora.id
  instance_type = var.aws_instance_type
  key_name      = var.aws_ssh_key_name
  subnet_id     = aws_subnet.cpxy_subnets[count.index % length(aws_subnet.cpxy_subnets)].id

  tags = {
    Name = "cpxy_node_${count.index}"
  }
}

data "aws_route53_zone" "zone" {
  name = var.aws_hosted_zone_name
}

resource "aws_route53_record" "dns_records" {
  count   = length(aws_instance.cpxy_nodes)
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "proxy.aws"
  type    = "A"
  ttl     = "300"

  weighted_routing_policy {
    weight = 100
  }

  set_identifier = aws_instance.cpxy_nodes[count.index].tags["Name"]
  records        = [aws_instance.cpxy_nodes[count.index].public_ip]
}
