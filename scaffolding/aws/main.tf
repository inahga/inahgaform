module "iam" {
  source   = "./iam"
  ssh_keys = var.ssh_keys
}

module "route53" {
  source           = "./route53"
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

  lifecycle_rule {
    id      = "delete-old-github-backups"
    enabled = true
    prefix  = "github/"

    expiration {
      days = 30
    }

    noncurrent_version_expiration {
      days = 30
    }
  }
}

resource "aws_s3_bucket_object" "github" {
  bucket = aws_s3_bucket.inahga.id
  key    = "github/"
  source = "/dev/null"
}

resource "aws_iam_user" "github_put" {
  name = "github-put"
}

resource "aws_iam_policy" "github_put" {
  name = "github-put"
  path = "/"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.inahga.arn}/github/*"
    }
  ]
}
EOT
}

resource "aws_iam_user_policy_attachment" "github_put" {
  user       = aws_iam_user.github_put.name
  policy_arn = aws_iam_policy.github_put.arn
}

resource "aws_s3_bucket_public_access_block" "inahga" {
  bucket                  = aws_s3_bucket.inahga.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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

