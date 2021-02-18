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

resource "aws_s3_bucket" "inahga-public" {
  bucket = "inahga-public"
  acl    = "public-read"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::inahga-public/*"
            ]
        }
    ]
}
EOF
}

resource "aws_s3_bucket_public_access_block" "inahga" {
  bucket                  = aws_s3_bucket.inahga.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
