# Creates a VPC and divides it into two subnets

resource "aws_vpc" "cloud_proxy" {
  cidr_block           = "10.10.0.0/27"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "cloud_proxy"
  }
}

resource "aws_subnet" "cloud_proxy_0" {
  vpc_id     = aws_vpc.cloud_proxy.id
  cidr_block = "10.10.0.0/28"
  tags = {
    Name = "cloud_proxy_0"
  }
  map_public_ip_on_launch = true
}

resource "aws_subnet" "cloud_proxy_1" {
  vpc_id     = aws_vpc.cloud_proxy.id
  cidr_block = "10.10.0.16/28"
  tags = {
    Name = "cloud_proxy_1"
  }
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "cloud_proxy_gateway" {
  vpc_id = aws_vpc.cloud_proxy.id
  tags = {
    Name = "cloud_proxy_gateway"
  }
}

resource "aws_route_table" "cloud_proxy_default" {
  vpc_id = aws_vpc.cloud_proxy.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloud_proxy_gateway.id
  }
  tags = {
    Name = "cloud_proxy_default"
  }
}

resource "aws_main_route_table_association" "cloud_proxy_association" {
  vpc_id         = aws_vpc.cloud_proxy.id
  route_table_id = aws_route_table.cloud_proxy_default.id
}

resource "aws_default_network_acl" "cloud_proxy_default_nacl" {
  default_network_acl_id = aws_vpc.cloud_proxy.default_network_acl_id

  ingress {
    protocol   = "tcp"
    rule_no    = 10
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 20
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 30
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
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
    Name = "cloud_proxy_default_nacl"
  }
}

resource "aws_default_security_group" "cloud_proxy_default_sg" {
  vpc_id = aws_vpc.cloud_proxy.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloud_proxy_default_sg"
  }
}
