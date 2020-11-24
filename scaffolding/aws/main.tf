module "iam" {
  source   = "./iam"
  ssh_keys = var.ssh_keys
}

module "route53" {
  source           = "./route53"
  local_ip_address = var.local_ip_address
}

resource "aws_s3_bucket" "inahga" {
  bucket = "inahga"
  acl    = "private"

  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
