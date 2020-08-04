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

resource "aws_instance" "lb_node" {
  ami           = data.aws_ami.fedora.id
  instance_type = var.aws_instance_type
  key_name      = var.aws_ssh_key_name
  subnet_id     = aws_subnet.cloud_proxy_0.id
}
