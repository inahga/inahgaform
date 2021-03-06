output "lb_nodes_public_ip" {
  value = aws_instance.cpxy_nodes[*].public_ip
}

output "lb_nodes_public_dns" {
  value = aws_instance.cpxy_nodes[*].public_dns
}

resource "local_file" "ansible_inventory" {
  filename = var.inventory_file
  content = <<EOT
[aws_proxy_nodes]
${join("\n", formatlist(
  "%s ansible_host=%s ansible_user=centos ansible_port=${var.aws_ssh_port}",
  aws_instance.cpxy_nodes.*.public_dns,
  aws_instance.cpxy_nodes.*.public_ip
))}
EOT
}
