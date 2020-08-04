output "lb_node_public_ip" {
  value = aws_instance.lb_node.public_ip
}
