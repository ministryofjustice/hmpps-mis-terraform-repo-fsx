# primary ec2
output "admin_instance_ids" {
  value = aws_instance.admin_server.*.id
}

output "admin_private_ips" {
  value = aws_instance.admin_server.*.private_ip
}

# dns
output "admin_primary_dns" {
  value = aws_route53_record.admin_dns.*.fqdn
}

output "admin_primary_dns_ext" {
  value = aws_route53_record.admin_dns.*.fqdn
}

#admin ami_id
output "admin_ami_id" {
  value = aws_instance.admin_server.*.ami
}

#admin instance_type
output "admin_instance_type" {
  value = aws_instance.admin_server.*.instance_type
}


output "ad_dns_ip_1" {
  value = local.ad_dns_ip_1
}
output "ad_dns_ip_2" {
  value = local.ad_dns_ip_2
}
