# Creates haproxy ec2 instances
# Creates a elb for these lbs
# Points route53 to the elb
#

# resource "aws_instance" "lb_node" {
#     ami = var.aws_ami_id
#     instance_type = var.aws_instance_type
#     key_name = var.aws_ssh_key_name
# }
