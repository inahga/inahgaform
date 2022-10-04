terraform {
  backend "s3" {
    bucket         = "inahga-tf-state"
    key            = "wireguard.tfstate"
    region         = "us-west-2"
    dynamodb_table = "inahga_tf_state_locks"
    encrypt        = true
  }

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "digitalocean_apikey" {}

provider "digitalocean" {
  token = var.digitalocean_apikey
}

data "digitalocean_ssh_keys" "keys" {}

provider "aws" {
  region = "us-west-2"
}

data "aws_route53_zone" "zone" {
  name = "inahga.org."
}

resource "digitalocean_droplet" "wg" {
  image              = "ubuntu-20-04-x64"
  name               = "wg"
  region             = "nyc1"
  size               = "s-1vcpu-1gb"
  private_networking = false
  ssh_keys           = data.digitalocean_ssh_keys.keys.ssh_keys.*.id
  user_data          = <<EOT
#!/bin/bash -e
tee /etc/cron.weekly/update.sh <<EOF
#!/bin/bash -e
apt-get update
apt-get upgrade -y
EOF
chmod +x /etc/cron.weekly/update.sh
/etc/cron.weekly/update.sh
EOT
}

resource "aws_route53_record" "dns_records" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "wg"
  type    = "A"
  ttl     = "300"

  weighted_routing_policy {
    weight = 100
  }

  set_identifier = digitalocean_droplet.wg.name
  records        = [digitalocean_droplet.wg.ipv4_address]
}

output "ipv4_address" {
  value = digitalocean_droplet.wg.ipv4_address
}

resource "local_file" "ansible_inventory" {
  filename        = "inventory"
  file_permission = "0666"
  content         = <<EOT
all:
  hosts:
    wireguard:
      ansible_host: ${digitalocean_droplet.wg.ipv4_address}
      ansible_user: root
    alexandria:
      ansible_host: 192.168.50.181
      ansible_user: inahga
  vars:
    remote_pub_ip: ${digitalocean_droplet.wg.ipv4_address}
    remote_vpn_ip: 192.168.51.1
    remote_vpn_port: 21841
    local_vpn_ip: 192.168.51.2
    service_port: 6970
EOT
}
