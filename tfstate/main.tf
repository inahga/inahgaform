# Store the Terraform state in S3
# See https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa
#

provider "aws" {
  region = "us-west-2"
  # Use awscli to set the AWS credentials for your session.
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "inahga-tf-state"
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

resource "aws_dynamodb_table" "tf_state_locks" {
  name         = "inahga_tf_state_locks"
  billing_mode = "PAY_PER_REQUEST"

  # Name of this primary key is required by Terraform
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

# If rebuilding from scratch, you will need to comment this out first and run
# init/plan/apply to rebuild the S3/DynamoDB instances.
terraform {
  # Can't use variables in backend config, this is limitation of terraform.
  backend "s3" {
    bucket         = "inahga-tf-state"
    key            = "tfstate/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "inahga_tf_state_locks"
    encrypt        = true
  }
}
