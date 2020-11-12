# output "subnet_ids" {
#   value = local.subnet_ids
# }

#===============================
# MIS BFS FSx Filesystem
#===============================

output "mis_bfs_filesystem" {
  value = {
    id                             = aws_fsx_windows_file_system.mis_bfs.id
    arn                            = aws_fsx_windows_file_system.mis_bfs.arn
    name                           = local.bfs_filesystem_name
    dns_name                       = aws_fsx_windows_file_system.mis_bfs.dns_name
    network_interface_ids          = aws_fsx_windows_file_system.mis_bfs.network_interface_ids
    vpc_id                         = aws_fsx_windows_file_system.mis_bfs.vpc_id
    preferred_file_server_ip       = aws_fsx_windows_file_system.mis_bfs.preferred_file_server_ip
    remote_administration_endpoint = aws_fsx_windows_file_system.mis_bfs.remote_administration_endpoint
    preferred_subnet_id            = local.preferred_subnet_id
    secondary_subnet_id            = local.secondary_subnet_id
    security_group_id              = aws_security_group.mis-fsx.id
  }
}

# output "mis_bfs_filesystem_arn" {
#   value = aws_fsx_windows_file_system.mis_bfs.arn
# }

# output "mis_bfs_filesystem_name" {
#   value = local.bfs_filesystem_name
# }

# output "mis_bfs_filesystem_dns_name" {
#   value = aws_fsx_windows_file_system.mis_bfs.dns_name
# }

# output "mis_bfs_filesystem_id" {
#   value = aws_fsx_windows_file_system.mis_bfs.id
# }

# output "mis_bfs_filesystem_network_interface_ids" {
#   value = aws_fsx_windows_file_system.mis_bfs.network_interface_ids
# }

# output "mis_bfs_filesystem_vpc_id" {
#   value = aws_fsx_windows_file_system.mis_bfs.vpc_id
# }

# output "mis_bfs_filesystem_preferred_file_server_ip" {
#   value = aws_fsx_windows_file_system.mis_bfs.preferred_file_server_ip
# }

# output "mis_bfs_filesystem_remote_administration_endpoint" {
#   value = aws_fsx_windows_file_system.mis_bfs.remote_administration_endpoint
# }

# output "mis_bfs_filesystem_preferred_subnet_id" {
#   value = local.preferred_subnet_id
# }

# output "mis_bfs_filesystem_secondary_subnet_id" {
#   value = local.secondary_subnet_id
# }

# output "mis_fsx_aws_security_group_id" {
#   value = aws_security_group.mis-fsx.id
# }