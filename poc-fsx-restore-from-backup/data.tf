terraform {
  # The configuration for this backend will be filled in by Terragrunt
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {
  }
}

####################################################
# DATA SOURCE MODULES FROM OTHER TERRAFORM BACKENDS
####################################################
#-------------------------------------------------------------
### Getting the common details
#-------------------------------------------------------------
data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "${var.environment_type}/common/terraform.tfstate"
    region = var.region
  }
}

#-------------------------------------------------------------
### Getting the vpc details
#-------------------------------------------------------------
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}

#-------------------------------------------------------------
### Getting the active directory details
#-------------------------------------------------------------
data "terraform_remote_state" "activedirectory" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "${var.environment_type}/activedirectory/terraform.tfstate"
    region = var.region
  }
}


#-------------------------------------------------------------
### Getting the active directory details
#-------------------------------------------------------------
data "terraform_remote_state" "fsx" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "${var.environment_type}/fsx/terraform.tfstate"
    region = var.region
  }
}

#-------------------------------------------------------------
### Getting the FSx Filesystem details (for security group)
#-------------------------------------------------------------
data "terraform_remote_state" "fsx-integration" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "${var.environment_type}/fsx-integration/terraform.tfstate"
    region = var.region
  }
}

data "aws_ssm_parameter" "ad_admin_username" {
  name = "/delius-mis-dev/delius/mis-activedirectory/ad/ad_admin_username"
}

data "aws_ssm_parameter" "ad_admin_password" {
  name = "/delius-mis-dev/delius/mis-activedirectory/ad/ad_admin_password"
}