# primary ec2
output "test_instance_ids" {
  value = aws_instance.test_server.*.id
}

output "test_private_ips" {
  value = aws_instance.test_server.*.private_ip
}

# dns
output "test_primary_dns" {
  value = aws_route53_record.test_dns.*.fqdn
}

output "test_primary_dns_ext" {
  value = aws_route53_record.test_dns.*.fqdn
}

#test ami_id
output "test_ami_id" {
  value = aws_instance.test_server.*.ami
}

#test instance_type
output "test_instance_type" {
  value = aws_instance.test_server.*.instance_type
}


output "ad_dns_ip_1" {
  value = local.ad_dns_ip_1
}
output "ad_dns_ip_2" {
  value = local.ad_dns_ip_2
}
