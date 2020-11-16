# https://registry.terraform.io/providers/hashicorp/aws/2.70.0/docs/resources/fsx_windows_file_system

resource "aws_fsx_windows_file_system" "mis_bfs" {
  active_directory_id               = data.terraform_remote_state.activedirectory.outputs.mis_ad["id"]
  storage_capacity                  = 300
  throughput_capacity               = 64 # MB/Second in power of 2 increments. Minimum of 8 and maximum of 2048.
  subnet_ids                        = local.subnet_ids
  preferred_subnet_id               = local.preferred_subnet_id
  automatic_backup_retention_days   = 7 # Minimum of 0 and maximum of 90. Defaults to 7. Set to 0 to disable.
  copy_tags_to_backups              = true
  daily_automatic_backup_start_time = "06:00"
  security_group_ids                = [aws_security_group.mis-fsx.id]
  deployment_type                   = "MULTI_AZ_1"

  tags = merge(
    local.tags,
    {
      "Name" = local.bfs_filesystem_name
    },
  )

  # kms_key_id  = local.kms_key_id

  timeouts {
    create = "60m"
    delete = "60m"
  }

  # There is no FSx API for reading security_group_ids
  lifecycle {
    ignore_changes = [security_group_ids]
  }

}

# ndl-bfs-101-fsx.delius-mis-dev.internal
resource "aws_route53_record" "aws_fsx_windows_file_system" {
  zone_id = local.public_zone_id
  name    = "${local.bfs_filesystem_name}.${local.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_fsx_windows_file_system.mis_bfs.dns_name]
}