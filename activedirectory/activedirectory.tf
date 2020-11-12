
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_directory

resource "aws_directory_service_directory" "mis_ad" {   
  name        = "${local.environment_name}.internal"  # delius-mis-dev.internal
  short_name  = local.environment_name                # delius-mis-dev
  description = "Microsoft AD for ${local.environment_name}.internal"
  password    = local.ad_admin_password
  edition     = "Standard"
  type        = "MicrosoftAD"

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

