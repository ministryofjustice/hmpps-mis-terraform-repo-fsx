terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {
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

data "terraform_remote_state" "activedirectory" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "mis-dev/activedirectory/terraform.tfstate"
    region = var.region
  }
}
