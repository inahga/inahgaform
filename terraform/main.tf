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

data "aws_ami" "fedora" {
  owners = ["125523088429"]
  filter {
    name = "image-id"

    # Fedora 32
    values = ["ami-020405ee5d5747724"]
  }
}

resource "aws_instance" "cpxy_nodes" {
  count         = var.node_count
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
    count = length(aws_instance.cpxy_nodes)
    zone_id = data.aws_route53_zone.zone.zone_id
    name = "proxy.aws"
    type = "A"
    ttl = "300"

    weighted_routing_policy {
      weight = 100
    }

    set_identifier = aws_instance.cpxy_nodes[count.index].tags["Name"]
    records = [aws_instance.cpxy_nodes[count.index].public_ip]
}
