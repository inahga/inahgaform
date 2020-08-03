resource "aws_key_pair" "key_pairs" {
    for_each = var.ssh_keys
    key_name = each.key
    public_key = each.value
}
