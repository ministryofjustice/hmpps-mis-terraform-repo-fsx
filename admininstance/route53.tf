resource "aws_route53_record" "admin_dns" {
  count   = local.admin_server_count
  zone_id = local.private_zone_id
  name    = "${local.nart_prefix}${count.index + 1}-fsx.${local.internal_domain}"
  type    = "A"
  ttl     = "300"

  records = [element(aws_instance.admin_server.*.private_ip, count.index)]
}

resource "aws_route53_record" "admin_dns_ext" {
  count   = local.admin_server_count
  zone_id = local.public_zone_id
  name    = "${local.nart_prefix}${count.index + 1}-fsx.${local.external_domain}"
  type    = "A"
  ttl     = "300"
  records = [element(aws_instance.admin_server.*.private_ip, count.index)]
}