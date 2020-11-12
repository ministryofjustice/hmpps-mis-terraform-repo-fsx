resource "aws_route53_record" "bfs_dns" {
  count   = var.bfs_server_count
  zone_id = local.private_zone_id
  name    = "${local.nart_prefix}${count.index + 1}-fsx.${local.internal_domain}"
  type    = "A"
  ttl     = "300"

  records = [element(aws_instance.bfs_server.*.private_ip, count.index)]
}

resource "aws_route53_record" "bfs_dns_ext" {
  count   = var.bfs_server_count
  zone_id = local.public_zone_id
  name    = "${local.nart_prefix}${count.index + 1}-fsx.${local.external_domain}"
  type    = "A"
  ttl     = "300"
  records = [element(aws_instance.bfs_server.*.private_ip, count.index)]
}