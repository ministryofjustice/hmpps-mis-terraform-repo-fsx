# # https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html

resource "aws_cloudwatch_metric_alarm" "admininstance_CPUUtilization_warning" {
  count                     = length(data.terraform_remote_state.admininstance.outputs.admin_instance_ids)
  alarm_name                = "${var.environment_name}-fsx-admininstance-${count.index + 1}-CPUUtilization-cwa--warning"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "60"
  alarm_actions             = [data.aws_sns_topic.mis_alarm_notification.arn]
  ok_actions                = [data.aws_sns_topic.mis_alarm_notification.arn]
  alarm_description         = "ec2 cpu utilization for the MIS FSx Admin Instance ${count.index + 1} is greater than 60%"
  insufficient_data_actions = []
  tags                      = local.tags

  dimensions = {
    InstanceId = data.terraform_remote_state.admininstance.outputs.admin_instance_ids[count.index]
  }
}

resource "aws_cloudwatch_metric_alarm" "admininstance_CPUUtilization_critical" {
  count                     = length(data.terraform_remote_state.admininstance.outputs.admin_instance_ids)
  alarm_name                = "${var.environment_name}-fsx-admininstance-${count.index + 1}-CPUUtilization-cwa--critical"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_actions             = [data.aws_sns_topic.mis_alarm_notification.arn]
  ok_actions                = [data.aws_sns_topic.mis_alarm_notification.arn]
  alarm_description         = "ec2 cpu utilization for the MIS FSx Admin Instance ${count.index + 1} is greater than 80%"
  insufficient_data_actions = []
  tags                      = local.tags

  dimensions = {
    InstanceId = data.terraform_remote_state.admininstance.outputs.admin_instance_ids[count.index]
  }
}

resource "aws_cloudwatch_metric_alarm" "admininstance_StatusCheckFailed" {
  count                     = length(data.terraform_remote_state.admininstance.outputs.admin_instance_ids)
  alarm_name                = "${var.environment_name}-fsx-admininstance-${count.index + 1}-StatusCheckFailed--critical"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_actions             = [data.aws_sns_topic.mis_alarm_notification.arn]
  ok_actions                = [data.aws_sns_topic.mis_alarm_notification.arn]
  alarm_description         = "ec2 StatusCheckFailed for MIS FSx Admin instance ${count.index + 1}"
  insufficient_data_actions = []
  tags                      = local.tags

  dimensions = {
    InstanceId = data.terraform_remote_state.admininstance.outputs.admin_instance_ids[count.index]
  }
}

resource "aws_cloudwatch_metric_alarm" "admininstance_MemoryUtilization_warning" {
  count               = length(data.terraform_remote_state.admininstance.outputs.admin_instance_ids)
  alarm_name          = "${var.environment_name}-fsx-admininstance-${count.index + 1}-MemoryUtilization-cwa--warning"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "CWAgent"
  period              = "120"
  statistic           = "Average"
  threshold           = "85"
  alarm_description   = "Memory Utilization is averaging 85% for Admin Instance ${count.index + 1}."
  alarm_actions       = [data.aws_sns_topic.mis_alarm_notification.arn]
  ok_actions          = [data.aws_sns_topic.mis_alarm_notification.arn]

  dimensions = {
    InstanceId   = data.terraform_remote_state.admininstance.outputs.admin_instance_ids[count.index]
    objectname   = "Memory"
  }
}