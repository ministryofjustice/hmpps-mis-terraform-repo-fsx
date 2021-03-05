resource "aws_route53_record" "test_dns" {
  count   = local.test_server_count
  zone_id = local.private_zone_id
  name    = "${local.nart_prefix}${count.index + 1}.${local.internal_domain}"
  type    = "A"
  ttl     = "300"

  records = [element(aws_instance.test_server.*.private_ip, count.index)]
}

resource "aws_route53_record" "test_dns_ext" {
  count   = local.test_server_count
  zone_id = local.public_zone_id
  name    = "${local.nart_prefix}${count.index + 1}.${local.external_domain}"
  type    = "A"
  ttl     = "300"
  records = [element(aws_instance.test_server.*.private_ip, count.index)]
}