
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_directory

resource "aws_directory_service_directory" "mis_ad" {
  name        = "${local.environment_name}.local"    # delius-mis-dev.local
  short_name  = local.environment_name               # delius-mis-dev
  description = "Microsoft AD for ${local.environment_name}.local"
  password    = local.ad_admin_password
  enable_sso  = false
  type        = "MicrosoftAD"
  edition     = "Standard"
  

  vpc_settings {
    vpc_id     = local.vpc_id
    subnet_ids = local.subnet_ids
  }

  tags = merge(
    local.tags,
    {
      "Name" = local.environment_name
    },
  )
}
