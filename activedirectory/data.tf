terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {
  }
}

data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "${var.environment_type}/common/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}

# AD Admin User Password
# /delius-mis-dev/delius/mis-activedirectory/ad/ad_admin_password
data "aws_ssm_parameter" "ad_admin_password" {
  name = "/${local.environment_name}/delius/mis-activedirectory/ad/ad_admin_password"
}