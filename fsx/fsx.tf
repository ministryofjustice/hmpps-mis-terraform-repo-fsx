# https://registry.terraform.io/providers/hashicorp/aws/2.70.0/docs/resources/fsx_windows_file_system

resource "aws_fsx_windows_file_system" "mis_bfs" {

  active_directory_id               = data.terraform_remote_state.activedirectory.outputs.mis_ad["id"]
  storage_capacity                  = local.storage_capacity
  throughput_capacity               = local.throughput_capacity
  subnet_ids                        = local.subnet_ids
  preferred_subnet_id               = local.preferred_subnet_id
  automatic_backup_retention_days   = local.automatic_backup_retention_days
  copy_tags_to_backups              = local.copy_tags_to_backups
  daily_automatic_backup_start_time = local.daily_automatic_backup_start_time
  security_group_ids                = [aws_security_group.mis-fsx.id]
  deployment_type                   = local.deployment_type

  tags = merge(
    local.tags,
    {
      "Name" = local.bfs_filesystem_name
    }
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

