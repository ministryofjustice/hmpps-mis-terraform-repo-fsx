locals {

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
  directory_id      = data.terraform_remote_state.activedirectory.outputs.mis_ad["id"]
  directory_name    = data.terraform_remote_state.activedirectory.outputs.mis_ad["domain_name"]
  directory_dns_ips = data.terraform_remote_state.activedirectory.outputs.mis_ad_dns_ip_addresses

}