locals {

    environment_type = var.environment_type
    environment_name = var.environment_name

    mis_app_name = data.terraform_remote_state.common.outputs.mis_app_name
    lambda_name  = "${local.mis_app_name}-notify-ndmis-slack"

    tags = merge(
      data.terraform_remote_state.common.outputs.common_tags,
      {
        "sub-project" = local.mis_app_name,
        "source-code" = "https://github.com/ministryofjustice/hmpps-mis-terraform-repo-fsx"
      }
    )

    filesystemid = data.terraform_remote_state.fsx.outputs.mis_bfs_filesystem["id"]
}