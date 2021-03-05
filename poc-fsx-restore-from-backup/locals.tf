locals {
# mis_bfs_filesystem = {
#   "arn" = "arn:aws:fsx:eu-west-2:479759138745:file-system/fs-0294e1d37b7839c14"
#   "dns_name" = "amznfsxm47kdw3q.delius-mis-dev.local"
#   "id" = "fs-0294e1d37b7839c14"
#   "name" = "mis-bfs"
#   "network_interface_ids" = [
#     "eni-020954b64daf3c69d",
#     "eni-097df3fd02340c716",
#   ]
#   "preferred_file_server_ip" = "10.162.32.61"
#   "preferred_subnet_id" = "subnet-04df144b906ca7de1"
#   "remote_administration_endpoint" = "amznfsxmcydprp6.delius-mis-dev.local"
#   "secondary_subnet_id" = "subnet-0383849fd4154f321"
#   "security_group_id" = "sg-0854acd3e24ff1f16"
#   "storage_capacity" = 300
#   "storage_type" = "SSD"
#   "tags" = {
#     "application" = "delius"
#     "autostop-mis-dev" = "True"
#     "bastion_inventory" = "dev"
#     "business-unit" = "hmpps"
#     "environment" = "mis-dev"
#     "environment-name" = "delius-mis-dev"
#     "infrastructure-support" = "Digital Studio"
#     "is-production" = "false"
#     "owner" = "Digital Studio"
#     "provisioned-with" = "Terraform"
#     "region" = "eu-west-2"
#     "source-code" = "https://github.com/ministryofjustice/hmpps-mis-terraform-repo-fsx"
#     "sub-project" = "mis"
#   }
#   "throughput_capacity" = 64
#   "vpc_id" = "vpc-0b4fc90ab0de60764"
# }

  # set this to the backupid we wish to restore
  FSxBackupId   = "aaaaddd"

  filesystem_name     = data.terraform_remote_state.fsx.outputs.mis_bfs_filesystem["name"]
  
  deployment_type     = data.terraform_remote_state.fsx.outputs.mis_bfs_filesystem["deployment_type"]
  preferred_subnet_id = data.terraform_remote_state.fsx.outputs.mis_bfs_filesystem["preferred_subnet_id"]
  secondary_subnet_id = data.terraform_remote_state.fsx.outputs.mis_bfs_filesystem["secondary_subnet_id"]
  security_group_id   = data.terraform_remote_state.fsx.outputs.mis_bfs_filesystem["security_group_id"]
  storage_type        = data.terraform_remote_state.fsx.outputs.mis_bfs_filesystem["storage_type"]

  tags                = data.terraform_remote_state.fsx.outputs.mis_bfs_filesystem["tags"]
  throughput_capacity = data.terraform_remote_state.fsx.outputs.mis_bfs_filesystem["throughput_capacity"]
  weekly_maintenance_start_time = data.terraform_remote_state.fsx.outputs.mis_bfs_filesystem["weekly_maintenance_start_time"]
  daily_automatic_backup_start_time = data.terraform_remote_state.fsx.outputs.mis_bfs_filesystem["daily_automatic_backup_start_time"]
  automatic_backup_retention_days = data.terraform_remote_state.fsx.outputs.mis_bfs_filesystem["automatic_backup_retention_days"]
  
  # ================================================================================
  # Active Directory
  # ================================================================================
  ad_id       = data.terraform_remote_state.activedirectory.outputs.mis_ad["id"]
  domain_name = data.terraform_remote_state.activedirectory.outputs.mis_ad["domain_name"]
  domain_short_name = data.terraform_remote_state.activedirectory.outputs.mis_ad["domain_short_name"]
   
  dns_ip_addresses = data.terraform_remote_state.activedirectory.outputs.mis_ad_dns_ip_addresses
  dns_ip_primary   = local.dns_ip_addresses[0]
  dns_ip_secondary = local.dns_ip_addresses[1]

  aliases = "${local.filesystem_name}.${local.domain_name}"

}
