# resource "aws_backup_vault" "bfs_ec2_backup_vault" {
#   name = "${var.environment_name}-bfs-ec2-bkup-pri-vlt"
#   tags = merge(
#     local.tags,
#     {
#       "Name" = "${var.environment_name}-bfs-ec2-bkup-pri-vlt"
#     },
#   )
# }

# resource "aws_backup_plan" "bfs_ec2_backup_plan" {
#   name = "${var.environment_name}-bfs-ec2-bkup-pri-pln"

#   rule {
#     rule_name         = "MIS EC2 instance volume backup"
#     target_vault_name = aws_backup_vault.bfs_ec2_backup_vault.name
#     schedule          = var.ebs_backup["schedule"]

#     lifecycle {
#       delete_after = var.ebs_backup["delete_after"]
#     }
#   }

#   tags = merge(
#     local.tags,
#     {
#       "Name" = "${var.environment_name}-bfs-ec2-bkup-pri-pln"
#     },
#   )
# }

# resource "aws_backup_selection" "bfs_ec2_backup_selection" {
#   iam_role_arn = data.terraform_remote_state.iam.outputs.mis_ec2_backup_role_arn
#   name         = "${var.environment_name}-bfs-ec2-bkup-pri-sel"
#   plan_id      = aws_backup_plan.bfs_ec2_backup_plan.id

#   selection_tag {
#     type  = "STRINGEQUALS"
#     key   = var.snap_tag
#     value = "1"
#   }
# }

