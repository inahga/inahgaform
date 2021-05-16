terraform {
  backend "s3" {
    bucket         = "inahga-tf-state"
    key            = "watchtogether.tfstate"
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

variable "nginx_password" {
  default = "12345"
}

provider "digitalocean" {
  token = var.digitalocean_apikey
}

provider "aws" {
  region = "us-west-2"
}

data "aws_route53_zone" "zone" {
  name = "inahga.org."
}

data "digitalocean_ssh_keys" "keys" {}

resource "digitalocean_droplet" "wt" {
  image              = "ubuntu-20-04-x64"
  name               = "wt"
  region             = "nyc1"
  size               = "s-1vcpu-1gb"
  private_networking = false
  ssh_keys           = data.digitalocean_ssh_keys.keys.ssh_keys.*.id
  user_data          = <<EOT
#!/bin/bash
set -euo pipefail

apt-get update
apt-get install nginx libnginx-mod-rtmp -y

tee /etc/nginx/nginx.conf <<'EOF'
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 768;
}

rtmp {
    server {
        listen 1935;
        chunk_size 4096;
        notify_method GET;

        application live {
            live on;
            on_publish http://localhost:80/auth;
            on_play http://localhost:80/auth;
            record off;
        }
    }
}

http {
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    server {
        listen 80;
        location /auth {
            if ($arg_pass = '12345') {
                return 201;
            }
            return 401;
        }
    }
}
EOF

systemctl enable nginx --now
EOT
}

resource "aws_route53_record" "dns_records" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "wt"
  type    = "A"
  ttl     = "300"

  weighted_routing_policy {
    weight = 100
  }

  set_identifier = digitalocean_droplet.wt.name
  records        = [digitalocean_droplet.wt.ipv4_address]
}

output "ipv4_address" {
  value = digitalocean_droplet.wt.ipv4_address
}
