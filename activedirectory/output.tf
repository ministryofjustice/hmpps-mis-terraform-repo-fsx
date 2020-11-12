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
  }
}

# output "mis_ad_id" {
#   value = aws_directory_service_directory.mis_ad.id
# }

# output "mis_ad_access_url" {
#   value = aws_directory_service_directory.mis_ad.access_url
# }

output "mis_ad_dns_ip_addresses" {
  value = sort(aws_directory_service_directory.mis_ad.dns_ip_addresses)
}

# output "mis_ad_security_group_id" {
#   value = aws_directory_service_directory.mis_ad.security_group_id
# }
