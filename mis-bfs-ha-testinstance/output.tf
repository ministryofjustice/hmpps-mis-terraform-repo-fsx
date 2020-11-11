# primary ec2
output "bfs_instance_ids" {
  value = aws_instance.bfs_server.*.id
}

output "bfs_private_ips" {
  value = aws_instance.bfs_server.*.private_ip
}

# dns
output "bfs_primary_dns" {
  value = aws_route53_record.bfs_dns.*.fqdn
}

output "bfs_primary_dns_ext" {
  value = aws_route53_record.bfs_dns.*.fqdn
}

#bfs ami_id
output "bfs_ami_id" {
  value = aws_instance.bfs_server.*.ami
}

#bfs instance_type
output "bfs_instance_type" {
  value = aws_instance.bfs_server.*.instance_type
}
