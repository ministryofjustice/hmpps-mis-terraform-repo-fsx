locals {

  environment_identifier = data.terraform_remote_state.common.outputs.environment_identifier
  environment_name       = var.environment_name
  common_name            = "${local.environment_identifier}-${var.mis_app_name}"
  public_zone_id         = data.terraform_remote_state.common.outputs.public_zone_id
  private_zone_id        = data.terraform_remote_state.common.outputs.private_zone_id
  bfs_filesystem_name    = "mis-bfs"

  vpc_id             = data.terraform_remote_state.common.outputs.vpc_id
  private_subnet_map = data.terraform_remote_state.common.outputs.private_subnet_map
  private_subnet_ids = data.terraform_remote_state.common.outputs.private_subnet_ids

  # kms_key_id            = var.kms_key_id
  tags = merge(
    data.terraform_remote_state.vpc.outputs.tags,
    {
      "sub-project" = var.mis_app_name
    }
  )
  # with ActiveDirectory the subnets must be total of 2 in different AZs
  # we are using eu-west-2a and eu-west-2b private subnets as this is where BFS instances are deployed to.
  subnet_ids = tolist([local.private_subnet_ids[0], local.private_subnet_ids[1]])

  # set preferred subnetid to eu-west-2a private subnet
  preferred_subnet_id = local.private_subnet_ids[0]
  # secondary subnet id is calculated by AWS 
  # as we can only pass in 2 subnets and must specify the
  # preferred_subnet_id so it'll be the other one :o)
  secondary_subnet_id = local.private_subnet_ids[1]


  domain_name = data.terraform_remote_state.activedirectory.outputs.mis_ad["domain_name"]
}
