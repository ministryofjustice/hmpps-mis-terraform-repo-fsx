locals {

  # ================================================================================
  # VPC
  # ================================================================================
  vpc_id             = data.terraform_remote_state.common.outputs.vpc_id
  private_subnet_map = data.terraform_remote_state.common.outputs.private_subnet_map
  private_subnet_ids = data.terraform_remote_state.common.outputs.private_subnet_ids

  # ================================================================================
  # Route53
  # ================================================================================
  public_zone_id  = data.terraform_remote_state.common.outputs.public_zone_id
  private_zone_id = data.terraform_remote_state.common.outputs.private_zone_id

  # ================================================================================
  # Common
  # ================================================================================
  environment_identifier = data.terraform_remote_state.common.outputs.environment_identifier
  environment_name       = var.environment_name
  common_name            = "${local.environment_identifier}-${var.mis_app_name}"
  bfs_filesystem_name    = "mis-bfs"

  # kms_key_id            = var.kms_key_id
  tags = merge(
    data.terraform_remote_state.vpc.outputs.tags,
    {
      "sub-project" = var.mis_app_name,
      "source-code" = "https://github.com/ministryofjustice/hmpps-mis-terraform-repo-fsx"
    }
  )

  # ================================================================================
  # Active Directory
  # ================================================================================
  # with ActiveDirectory the subnets must be total of 2 in different AZs
  # we are using eu-west-2a and eu-west-2b private subnets as this is where BFS instances are deployed to.
  subnet_ids = tolist([local.private_subnet_ids[0], local.private_subnet_ids[1]])

  # set preferred subnetid to eu-west-2a private subnet
  preferred_subnet_id = local.private_subnet_ids[0]

  # secondary subnet id is calculated by AWS as we can only pass in 2 subnets
  # preferred_subnet_id is 1st subnet_id
  # secondary subnet_id is 2nd subnet_id
  secondary_subnet_id = local.private_subnet_ids[1]

  # ================================================================================
  # Active Directory
  # ================================================================================
  domain_name                        = data.terraform_remote_state.activedirectory.outputs.mis_ad["domain_name"]
  mis_fsx_integration_security_group = data.terraform_remote_state.fsx-integration.outputs.mis_fsx_integration_security_group

  storage_type                    = "SSD"
  automatic_backup_retention_days = 7  # Minimum of 0 and maximum of 90. Defaults to 7. Set to 0 to disable.

  copy_tags_to_backups = var.fsx_copy_tags_to_backups

  daily_automatic_backup_start_time = "03:00"
  deployment_type                   = "MULTI_AZ_1"

  weekly_maintenance_start_time = "2:02:30"
  aliases                       = local.common_name

  fsx_bfs_fileshare_size       = var.fsx_bfs_fileshare_size
  fsx_bfs_fileshare_throughput = var.fsx_bfs_fileshare_throughput # MB/Second in power of 2 increments. Minimum of 8 and maximum of 2048.

  counterpart_mp_env_cidr = {
    delius-mis-dev  = "10.26.24.0/21" #mp hmpps-development
    delius-stage    = "10.27.0.0/21"  #mp hmpps-preproduction
    delius-pre-prod = "10.27.0.0/21"  #mp hmpps-preproduction
    delius-prod     = "10.27.8.0/21"  #mp hmpps-production
  }
}
