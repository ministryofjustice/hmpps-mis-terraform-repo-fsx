
locals {

  environment_identifier = data.terraform_remote_state.common.outputs.environment_identifier
  vpc_id                 = data.terraform_remote_state.common.outputs.vpc_id
  environment_name       = var.environment_name

  private_subnet_map = data.terraform_remote_state.common.outputs.private_subnet_map
  private_subnet_ids = data.terraform_remote_state.common.outputs.private_subnet_ids

  tags = merge(
    data.terraform_remote_state.vpc.outputs.tags,
    {
      "sub-project" = var.mis_app_name
      "source-code" = "https://github.com/ministryofjustice/hmpps-mis-terraform-repo-fsx"
    }
  )

  sg_outbound_id = data.terraform_remote_state.common.outputs.common_sg_outbound_id

  mis_ad_security_group_id = data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]
  ad_dns_ip_1              = data.terraform_remote_state.activedirectory.outputs.mis_ad["dns_ip_addresses"][0]
  ad_dns_ip_2              = data.terraform_remote_state.activedirectory.outputs.mis_ad["dns_ip_addresses"][1]
  ad_domain_name           = data.terraform_remote_state.activedirectory.outputs.mis_ad["domain_name"]

}
