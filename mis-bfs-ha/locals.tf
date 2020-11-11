locals {

  environment_identifier = data.terraform_remote_state.common.outputs.environment_identifier
  common_name            = "${local.environment_identifier}-${var.mis_app_name}"
  bfs_filesystem_name    = "mis-bfs"
  vpc_id                 = data.terraform_remote_state.common.outputs.vpc_id
  environment_name       = var.environment_name
  private_subnet_map     = data.terraform_remote_state.common.outputs.private_subnet_map
  private_subnet_ids     = data.terraform_remote_state.common.outputs.private_subnet_ids
  # kms_key_id            = var.kms_key_id
  tags = merge(
    data.terraform_remote_state.vpc.outputs.tags,
    {
      "sub-project" = var.mis_app_name
    }
  )
  # with ActiveDirectory the subnets must be total of 2 in different AZs
  # we are using eu-west-2a and eu-west-2b private subnets as this is where BFS instances are deployed to.
  subnet_ids             = tolist([local.private_subnet_ids[0], local.private_subnet_ids[1]])

  # set preferred subnetid to eu-west-2a private subnet
  preferred_subnet_id    = local.private_subnet_ids[0]
  # secondary subnet id is calculated by AWS 
  # as we can only pass in 2 subnets and must specify the
  # preferred_subnet_id so it'll be the other one :o)
  secondary_subnet_id    = local.private_subnet_ids[1]

  # security group to allow BFS instances to access the FSx fileshare and AD
  nextcloud_samba_sg     = data.terraform_remote_state.network-security-groups.outputs.sg_mis_samba

  # security group rule CIDR to allow BFS instance connectivity to AD & FSx filesystem
  ad_cidr_blocks         = ["0.0.0.0/0"]
}
