#
#

output "aws_s3_tf_state_bucket" {
    value = aws_s3_bucket.tf_state.arn
    description = "ARN of the S3 bucket holding the Terraform state."
}

output "aws_dynamodb_tf_state_locks_name" {
    value = aws_dynamodb_table.tf_state_locks.name
    description = "Name of the DynamoDB table holding the Terraform state locks."
}
