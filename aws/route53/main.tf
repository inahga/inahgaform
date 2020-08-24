resource "aws_route53_zone" "inahga_org" {
  name = "inahga.org"
}

resource "aws_route53_record" "dmz_inahga_org" {
  zone_id = aws_route53_zone.inahga_org.zone_id
  name    = "dmz"
  type    = "A"
  ttl     = "300"
  records = [var.local_ip_address]
}
