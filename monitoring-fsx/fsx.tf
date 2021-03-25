

resource "aws_cloudwatch_metric_alarm" "fsx_filesystem_warning" {
  count                     = length(data.terraform_remote_state.admininstance.outputs.admin_instance_ids)
  alarm_name                = "${var.environment_name}-FSXFileSystem-FreeStorageCapacity-cwa--warning"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "FreeStorageCapacity"
  namespace                 = "AWS/FSx"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "64424509440"
  alarm_actions             = [data.aws_sns_topic.mis_alarm_notification.arn]
  ok_actions                = [data.aws_sns_topic.mis_alarm_notification.arn]
  alarm_description         = "FSx Filesystem Free Storage Capacity is less than 20% (60GB)"
  insufficient_data_actions = []
  tags                      = local.tags

  dimensions = {
    FileSystemId = data.terraform_remote_state.fsx.outputs.mis_bfs_filesystem["id"]
  }
}


resource "aws_cloudwatch_metric_alarm" "fsx_filesystem_critical" {
  count                     = length(data.terraform_remote_state.admininstance.outputs.admin_instance_ids)
  alarm_name                = "${var.environment_name}-FSXFileSystem-FreeStorageCapacity-cwa--critical"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "FreeStorageCapacity"
  namespace                 = "AWS/FSx"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "32212254720"
  alarm_actions             = [data.aws_sns_topic.mis_alarm_notification.arn]
  ok_actions                = [data.aws_sns_topic.mis_alarm_notification.arn]
  alarm_description         = "FSx Filesystem Free Storage Capacity is less than 10% (30GB)"
  insufficient_data_actions = []
  tags                      = local.tags

  dimensions = {
    FileSystemId = data.terraform_remote_state.fsx.outputs.mis_bfs_filesystem["id"]
  }
}
