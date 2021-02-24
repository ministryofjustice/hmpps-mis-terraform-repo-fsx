resource "aws_cloudwatch_log_group" "mis_ad" {
  name              = "/aws/directoryservice/${aws_directory_service_directory.mis_ad.id}"
  retention_in_days = 14
}

data "aws_iam_policy_document" "ad-log-policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    principals {
      identifiers = ["ds.amazonaws.com"]
      type        = "Service"
    }

    resources = ["${aws_cloudwatch_log_group.mis_ad.arn}:*"]

    effect = "Allow"
  }
}

resource "aws_cloudwatch_log_resource_policy" "ad-log-policy" {
  policy_document = data.aws_iam_policy_document.ad-log-policy.json
  policy_name     = "ad-log-policy"
}

resource "aws_directory_service_log_subscription" "mis_ad" {
  directory_id   = aws_directory_service_directory.mis_ad.id
  log_group_name = aws_cloudwatch_log_group.mis_ad.name
}