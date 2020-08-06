output "lb_nodes_public_ip" {
  value = aws_instance.lb_nodes[*].public_ip
}
