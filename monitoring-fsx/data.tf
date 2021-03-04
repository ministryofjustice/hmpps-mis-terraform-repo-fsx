terraform {
  # The configuration for this backend will be filled in by Terragrunt
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

data "terraform_remote_state" "fsx" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "${var.environment_type}/fsx/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "admininstance" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "${var.environment_type}/admininstance/terraform.tfstate"
    region = var.region
  }
}


data "aws_sns_topic" "mis_alarm_notification" {
  name = "${local.mis_app_name}-alarm-notification"
}

data "aws_lambda_function" "notify-ndmis-slack" {
  function_name = local.lambda_name
}

