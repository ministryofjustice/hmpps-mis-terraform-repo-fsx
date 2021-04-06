# output "subnet_ids" {
#   value = local.subnet_ids
# }

#===============================
# MIS BFS FSx Filesystem
#===============================

output "mis_bfs_filesystem" {
  value = {
    id                                = aws_fsx_windows_file_system.mis_bfs.id
    arn                               = aws_fsx_windows_file_system.mis_bfs.arn
    name                              = local.bfs_filesystem_name
    dns_name                          = aws_fsx_windows_file_system.mis_bfs.dns_name
    network_interface_ids             = aws_fsx_windows_file_system.mis_bfs.network_interface_ids
    vpc_id                            = aws_fsx_windows_file_system.mis_bfs.vpc_id
    preferred_file_server_ip          = aws_fsx_windows_file_system.mis_bfs.preferred_file_server_ip
    remote_administration_endpoint    = aws_fsx_windows_file_system.mis_bfs.remote_administration_endpoint
    preferred_subnet_id               = local.preferred_subnet_id
    secondary_subnet_id               = local.secondary_subnet_id
    security_group_id                 = aws_security_group.mis-fsx.id
    storage_capacity                  = local.fsx_bfs_fileshare_size
    storage_type                      = local.storage_type
    throughput_capacity               = local.fsx_bfs_fileshare_throughput
    tags                              = local.tags
    deployment_type                   = local.deployment_type
    weekly_maintenance_start_time     = local.weekly_maintenance_start_time
    daily_automatic_backup_start_time = local.daily_automatic_backup_start_time
    automatic_backup_retention_days   = local.automatic_backup_retention_days
    aliases                           = local.aliases
  }
}

output "bfs_filesystem_network_interface_ids" {
  value = aws_fsx_windows_file_system.mis_bfs.network_interface_ids
}

data "aws_network_interface" "bfs_filesystem_eni_1" {
  id = element(sort(aws_fsx_windows_file_system.mis_bfs.network_interface_ids), 0)
}

data "aws_network_interface" "bfs_filesystem_eni_2" {
  id = element(sort(aws_fsx_windows_file_system.mis_bfs.network_interface_ids), 1)
}

output "mis_bfs_filesystem_eni_primary" {
  value = {
    availability_zone = data.aws_network_interface.bfs_filesystem_eni_1.availability_zone
    description       = data.aws_network_interface.bfs_filesystem_eni_1.description
    private_dns_name  = data.aws_network_interface.bfs_filesystem_eni_1.private_dns_name
    private_ips       = data.aws_network_interface.bfs_filesystem_eni_1.private_ips
    subnet_id         = data.aws_network_interface.bfs_filesystem_eni_1.subnet_id
    security_groups   = data.aws_network_interface.bfs_filesystem_eni_1.security_groups
    tags              = data.aws_network_interface.bfs_filesystem_eni_1.tags
    vpc_id            = data.aws_network_interface.bfs_filesystem_eni_1.vpc_id
  }
}

output "mis_bfs_filesystem_eni_standby" {
  value = {
    availability_zone = data.aws_network_interface.bfs_filesystem_eni_2.availability_zone
    description       = data.aws_network_interface.bfs_filesystem_eni_2.description
    private_dns_name  = data.aws_network_interface.bfs_filesystem_eni_2.private_dns_name
    private_ips       = data.aws_network_interface.bfs_filesystem_eni_2.private_ips
    subnet_id         = data.aws_network_interface.bfs_filesystem_eni_2.subnet_id
    security_groups   = data.aws_network_interface.bfs_filesystem_eni_2.security_groups
    tags              = data.aws_network_interface.bfs_filesystem_eni_2.tags
    vpc_id            = data.aws_network_interface.bfs_filesystem_eni_2.vpc_id
  }
}

output "mis_bfs_filesystem_eni_secondary_ips" {
  value = tolist([
    element(data.aws_network_interface.bfs_filesystem_eni_1.private_ips, 1),
    element(data.aws_network_interface.bfs_filesystem_eni_2.private_ips, 1)
  ])
}

output "mis_bfs_filesystem_security_group" {
  value = {
    id          = aws_security_group.mis-fsx.id
    arn         = aws_security_group.mis-fsx.arn
    vpc_id      = aws_security_group.mis-fsx.vpc_id
    owner_id    = aws_security_group.mis-fsx.owner_id
    name        = aws_security_group.mis-fsx.name
    description = aws_security_group.mis-fsx.description
    ingress     = aws_security_group.mis-fsx.ingress
    egress      = aws_security_group.mis-fsx.egress
  }
}
