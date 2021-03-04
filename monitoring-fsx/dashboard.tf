#dashboard

resource "aws_cloudwatch_dashboard" "misfsx" {
  dashboard_name = "mis-${local.environment_name}-monitoring-fsx"
  dashboard_body = data.template_file.dashboard-body.rendered
}

data "template_file" "dashboard-body" {
  template = file("templates/mis-fsx-dashboard.json")
  vars = {
    region            = var.region
    environment_name  = local.environment_name
    filesystemid      = local.filesystemid
  }
}