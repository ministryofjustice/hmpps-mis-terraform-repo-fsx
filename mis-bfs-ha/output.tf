output "subnet_ids" {
  value = local.subnet_ids
}

#===============================
# MIS Active Directory
#===============================

output "mis_ad_id" {
  value = aws_directory_service_directory.mis_ad.id
}

output "mis_ad_access_url" {
  value = aws_directory_service_directory.mis_ad.access_url
}

output "mis_ad_dns_ip_addresses" {
  value = aws_directory_service_directory.mis_ad.dns_ip_addresses
}

output "mis_ad_security_group_id" {
  value = aws_directory_service_directory.mis_ad.security_group_id
}

#===============================
# MIS BFS FSx Filesystem
#===============================

output "mis_bfs_filesystem_arn" {
  value = aws_fsx_windows_file_system.mis_bfs.arn
}

output "mis_bfs_filesystem_name" {
  value = local.bfs_filesystem_name
}


output "mis_bfs_filesystem_dns_name" {
  value = aws_fsx_windows_file_system.mis_bfs.dns_name
}

output "mis_bfs_filesystem_id" {
  value = aws_fsx_windows_file_system.mis_bfs.id
}

output "mis_bfs_filesystem_network_interface_ids" {
  value = aws_fsx_windows_file_system.mis_bfs.network_interface_ids
}

output "mis_bfs_filesystem_vpc_id" {
  value = aws_fsx_windows_file_system.mis_bfs.vpc_id
}

output "mis_bfs_filesystem_preferred_file_server_ip" {
  value = aws_fsx_windows_file_system.mis_bfs.preferred_file_server_ip
}

output "mis_bfs_filesystem_remote_administration_endpoint" {
  value = aws_fsx_windows_file_system.mis_bfs.remote_administration_endpoint
}

output "mis_bfs_filesystem_preferred_subnet_id" {
  value = local.preferred_subnet_id
}

output "mis_bfs_filesystem_secondary_subnet_id" {
  value = local.secondary_subnet_id
}

output "mis_fsx_aws_security_group_id" {
  value = aws_security_group.mis-fsx.id
}