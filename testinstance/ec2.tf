data "template_file" "instance_userdata" {
  count    = var.bfs_server_count
  template = file("../userdata/userdata.tpl")

  vars = {
    host_name       = "${local.nart_prefix}${count.index + 1}-${random_string.random_hostname_suffix.result}"
    internal_domain = local.internal_domain
    user            = data.aws_ssm_parameter.user.value
    password        = data.aws_ssm_parameter.password.value
    bosso_user      = data.aws_ssm_parameter.bosso_user.value
    bosso_password  = data.aws_ssm_parameter.bosso_password.value
    ad_dns_ip_1     = local.ad_dns_ip_1
    ad_dns_ip_2     = local.ad_dns_ip_2
    ad_domain_name  = local.ad_domain_name
    bfs_filesystem_dns_name = local.bfs_filesystem_dns_name
  }
}

resource "null_resource" "userdatarenderdebug" {
  triggers = {
    json = data.template_file.instance_userdata[0].rendered
  }
}

resource "random_string" "random_hostname_suffix" {
  length    = 3
  lower     = true
  min_lower = 3
  upper     = false
  special   = false
  number    = false
}

# Iteratively create EC2 instances
resource "aws_instance" "bfs_server" {
  count         = var.bfs_server_count
  ami           = data.aws_ami.amazon_ami.id
  instance_type = var.bfs_instance_type

  # element() function wraps if index > list count, so we get an even distribution across AZ subnets
  subnet_id                   = element(values(local.private_subnet_map), count.index)
  iam_instance_profile        = local.instance_profile
  associate_public_ip_address = false
  vpc_security_group_ids = [
    local.sg_map_ids["sg_mis_app_in"],
    local.sg_map_ids["sg_mis_common"],
    local.sg_outbound_id,
    local.nextcloud_samba_sg,
    local.mis_fsx_aws_security_group_id
  ]
  key_name = local.ssh_deployer_key

  volume_tags = merge(
    {
      "Name" = "${local.environment_identifier}-${local.app_name}-${local.nart_prefix}${count.index + 1}"
    },
  )

  tags = merge(
    local.tags,
    {
      "Name" = "${local.environment_identifier}-${local.app_name}-${local.nart_prefix}${count.index + 1}-${random_string.random_hostname_suffix.result}"
    },
    {
      "CreateSnapshot" = 0
    },
  )

  monitoring = true
  user_data  = element(data.template_file.instance_userdata.*.rendered, count.index)

  root_block_device {
    volume_size = var.bfs_root_size
  }

  lifecycle {
    ignore_changes = [
      ami,
      # user_data,
    ]
  }
}
