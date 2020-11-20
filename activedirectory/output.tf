output "subnet_ids" {
  value = local.subnet_ids
}

#===============================
# MIS Active Directory
#===============================

output "mis_ad" {
  value = {
    id                = aws_directory_service_directory.mis_ad.id
    access_url        = aws_directory_service_directory.mis_ad.access_url
    dns_ip_addresses  = sort(aws_directory_service_directory.mis_ad.dns_ip_addresses)
    security_group_id = aws_directory_service_directory.mis_ad.security_group_id
    domain_name       = local.mis_ad_name
    domain_short_name = local.mis_ad_short_name
  }
}

output "mis_ad_dns_ip_addresses" {
  value = sort(aws_directory_service_directory.mis_ad.dns_ip_addresses)
}
