
resource "aws_route53_record" "aws_fsx_windows_file_system" {
  zone_id = local.private_zone_id
  name    = local.bfs_filesystem_name
  type    = "A"
  ttl     = "300"
  records = [
    element(data.aws_network_interface.bfs_filesystem_eni_1.private_ips, 1),
    element(data.aws_network_interface.bfs_filesystem_eni_2.private_ips, 1)
  ]
}