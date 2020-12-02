locals {

  vpc_id             = data.terraform_remote_state.common.outputs.vpc_id
  environment_name   = var.environment_name
  environment_identifier = data.terraform_remote_state.common.outputs.environment_identifier
  
  private_subnet_map = data.terraform_remote_state.common.outputs.private_subnet_map
  private_subnet_ids = data.terraform_remote_state.common.outputs.private_subnet_ids
  
  # kms_key_id            = var.kms_key_id
  
  # with ActiveDirectory the subnets must be total of 2 in different AZs
  # we are using eu-west-2a and eu-west-2b private subnets as this is where BFS instances are deployed to.
  subnet_ids = tolist([local.private_subnet_ids[0], local.private_subnet_ids[1]])

  # set preferred subnetid to eu-west-2a private subnet
  preferred_subnet_id = local.private_subnet_ids[0]

  # secondary subnet id is calculated by AWS 
  # As we can only pass in 2 subnets and MUST specify the
  # preferred_subnet_id so it'll be the other subnet
  # it'll be the eu-west-2b private subnet
  secondary_subnet_id = local.private_subnet_ids[1]

  ad_admin_password = var.ad_admin_password

  mis_ad_name       = "${local.environment_name}.local" # delius-mis-dev.local
  mis_ad_short_name = local.environment_name               # delius-mis-dev

  tags = merge(
    data.terraform_remote_state.vpc.outputs.tags,
    {
      "sub-project" = var.mis_app_name,
      "source-code" = "https://github.com/ministryofjustice/hmpps-mis-terraform-repo-fsx"
    }
  )

}
