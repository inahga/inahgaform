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

data "aws_route53_zone" "zone" {
  name = "inahga.org."
}

resource "aws_security_group" "csce494_security_group" {
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
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
    Name = "csce494_security_group"
  }
}

resource "aws_instance" "csce494" {
  # Ubuntu 20.04 LTS
  ami = "ami-0928f4202481dfdf6"

  instance_type          = "t3a.small"
  key_name               = "aghani"
  iam_instance_profile   = aws_iam_instance_profile.csce494_instance_profile.name
  vpc_security_group_ids = [aws_security_group.csce494_security_group.id]

  user_data = <<EOT
#!/bin/bash
set -eou pipefail

apt-get update
apt-get install git nodejs npm certbot python3-certbot-dns-route53 docker.io docker-compose mariadb-client -y

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDP+S4JXEjESV3Der0L8Tp3cpmRLeqqDLRDjBgDy0AFWszJKsRJi2BPEJZj/y7zionjFQZCmLUaHk+Z1CGyjyyfBzrFXJWQgLm3R/3KZzpWuxEGreuEDgPYWus3t1iALf6CSIliR309HVG1N5ec6qhkA7Vk9U8NwrG9GnW5unPoF2cMBIwjlvP053e5UvkOW0bN7Vtj+hPNUi0mpMpMj3zArHKjiZxX+QEsr8MpZ50cMlBt1rQ/pq9g1l5AaYEcBhX6JBmCx3WXk7VmN4Hv4beQofABBd8FqPQzzcSjt1Oo/I84NyFnuMJ5piRmQ/veWmFFou31rw5BmAA4fmPkz6CVLSWhI5lxWxH5XYJIOW77qLISNDIybbSMkWQFkHATxipFTF+EcYtAz3S2vDAOzyIrRzbXPJRjVuu+f0uR0h1bGcQHKxAiKQXSJptvyN8sTFNLVeiwaxRMp1mNBhng0YOPNimL9R1ECOYP74FYL9FJdN7nuGvizpfSFo6s49eUvWk= github-deploy-key" >> /home/ubuntu/.ssh/authorized_keys

systemctl enable docker
systemctl start docker

certbot certonly --dns-route53 -d csce494.inahga.org -n --agree-tos -m inahga@gmail.com

tee /etc/cron.weekly/renew.sh <<EOF
#!/bin/bash
set -euo pipefail

certbot renew
cd /opt/hafh/server
docker-compose restart hafh
EOF

chmod +x /etc/cron.weekly/renew.sh

tee /etc/cron.weekly/prune.sh <<EOF
#!/bin/bash
docker image prune
EOF

chmod +x /etc/cron.weekly/prune.sh

mkdir -p /opt/secrets
tee /opt/secrets/secrets.env >/dev/null <<EOF
JWT_SECRET=$(head -c64 /dev/urandom | sha512sum | head -c64)
NODE_ENV=production
PORT=443
MYSQL_ROOT_PASSWORD=$(head -c64 /dev/urandom | sha512sum | head -c64)
MYSQL_DATABASE=hafh
MYSQL_USER=hafh
MYSQL_PASSWORD=$(head -c64 /dev/urandom | sha512sum | head -c64)
TLS_CERT=/etc/letsencrypt/live/csce494.inahga.org/fullchain.pem
TLS_KEY=/etc/letsencrypt/live/csce494.inahga.org/privkey.pem
GCP_API_KEY=
EOF
chown root:root /opt/secrets/secrets.env
chmod 0600 /opt/secrets/secrets.env

cd /opt
git clone https://github.com/inahga/hafh
cd hafh/server
docker-compose --env-file /opt/secrets/secrets.env up -d
EOT

  tags = {
    Name = "csce494"
  }
}


resource "aws_route53_record" "dns_records" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "csce494"
  type    = "A"
  ttl     = "300"

  weighted_routing_policy {
    weight = 100
  }

  set_identifier = aws_instance.csce494.tags["Name"]
  records        = [aws_instance.csce494.public_ip]
}

resource "aws_iam_instance_profile" "csce494_instance_profile" {
  name = "csce494_instance_profile"
  role = "certrole"
}
