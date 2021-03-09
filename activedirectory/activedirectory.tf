
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_directory

resource "aws_directory_service_directory" "mis_ad" {
  name        = local.mis_ad_name
  short_name  = local.mis_ad_short_name 

  description = "Microsoft AD for ${local.environment_name}.local"
  password    = data.aws_ssm_parameter.ad_admin_password.value
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

  # Required as AWS does not allow you to change the Admin password post AD Create - you must destroy/recreate 
  # When we run tf plan against an already created AD it will always show the AD needs destroy/create so we ignore
  lifecycle {
    ignore_changes = [
      password
    ]
  }

}
