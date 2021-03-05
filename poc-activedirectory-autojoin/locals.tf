locals {
  internal_domain        = data.terraform_remote_state.common.outputs.internal_domain
  private_zone_id        = data.terraform_remote_state.common.outputs.private_zone_id
  external_domain        = data.terraform_remote_state.common.outputs.external_domain
  public_zone_id         = data.terraform_remote_state.common.outputs.public_zone_id
  environment_identifier = data.terraform_remote_state.common.outputs.environment_identifier

  environment_name   = var.environment_name
  region             = var.region
  app_name           = data.terraform_remote_state.common.outputs.mis_app_name
  private_subnet_map = data.terraform_remote_state.common.outputs.private_subnet_map
  nextcloud_samba_sg = data.terraform_remote_state.network-security-groups.outputs.sg_mis_samba

  sg_map_ids       = data.terraform_remote_state.security-groups.outputs.sg_map_ids
  instance_profile = data.terraform_remote_state.iam.outputs.iam_policy_int_app_instance_profile_name
  ssh_deployer_key = data.terraform_remote_state.common.outputs.common_ssh_deployer_key
  nart_role        = "ndl-tst-${data.terraform_remote_state.common.outputs.legacy_environment_name}"

  # Create a prefix that removes the final integer from the nart_role value
  nart_prefix = substr(local.nart_role, 0, length(local.nart_role) - 1)

  test_server_count  = 2
  test_instance_type = "t2.large"
  test_instance_ami  = "ami-023b643326f4d6eff"
  test_root_size     = 50

  sg_outbound_id = data.terraform_remote_state.common.outputs.common_sg_outbound_id

  mis_ad_security_group_id = data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]
  ad_dns_ip_1              = data.terraform_remote_state.activedirectory.outputs.mis_ad["dns_ip_addresses"][0]
  ad_dns_ip_2              = data.terraform_remote_state.activedirectory.outputs.mis_ad["dns_ip_addresses"][1]
  ad_domain_name           = data.terraform_remote_state.activedirectory.outputs.mis_ad["domain_name"]

  mis_fsx_aws_security_group_id = data.terraform_remote_state.fsx.outputs.mis_bfs_filesystem["security_group_id"]
  bfs_filesystem_dns_name       = data.terraform_remote_state.fsx.outputs.mis_bfs_filesystem["dns_name"]

  tags = merge(
    data.terraform_remote_state.common.outputs.common_tags,
    {
      "sub-project" = local.app_name,
      "source-code" = "https://github.com/ministryofjustice/hmpps-mis-terraform-repo-fsx"
    }
  )

  ssm_adjoin_document_name = data.terraform_remote_state.ssm.outputs.awsconfig_Domain_document["name"]
}