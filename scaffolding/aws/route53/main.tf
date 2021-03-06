resource "aws_route53_zone" "inahga_org" {
  name = "inahga.org"
}

resource "aws_route53_record" "simple_cnames" {
  for_each = var.simple_cnames
  zone_id  = aws_route53_zone.inahga_org.zone_id
  name     = each.key
  type     = "CNAME"
  ttl      = "300"
  records  = [each.value]
}
