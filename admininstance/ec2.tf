
data "template_file" "instance_userdata" {
  count    = local.admin_server_count
  template = file("./userdata/userdata.tpl")

  vars = {
    internal_domain          = local.internal_domain
    user                     = data.aws_ssm_parameter.user.value
    password                 = data.aws_ssm_parameter.password.value
    bosso_user               = data.aws_ssm_parameter.bosso_user.value
    bosso_password           = data.aws_ssm_parameter.bosso_password.value
    ad_dns_ip_1              = local.ad_dns_ip_1
    ad_dns_ip_2              = local.ad_dns_ip_2
    ad_domain_name           = local.ad_domain_name
    bfs_filesystem_dns_name  = local.bfs_filesystem_dns_name
    ssm_adjoin_document_name = local.ssm_adjoin_document_name
  }
}


resource "null_resource" "userdata_rendered" {
  triggers = {
    json = data.template_file.instance_userdata[0].rendered
  }
}

# Iteratively create EC2 instances
resource "aws_instance" "admin_server" {
  count         = local.admin_server_count
  ami           = local.admin_instance_ami 
  instance_type = local.admin_instance_type

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
      # "Name" = "${local.environment_identifier}-${local.app_name}-${local.nart_prefix}${count.index + 1}-fsx"
      "Name" = "${local.hostname}${count.index + 1}"
    },
  )

  tags = merge(
    local.tags,
    {
      # "Name" = "${local.environment_identifier}-${local.app_name}-${local.nart_prefix}${count.index + 1}-fsx"
      "Name" = "${local.hostname}${count.index + 1}"
    },
    {
      "CreateSnapshot" = 0
    },
  )

  monitoring = true

  root_block_device {
    volume_size = local.admin_root_size
  }

  user_data = element(data.template_file.instance_userdata.*.rendered, count.index)

  lifecycle {
    ignore_changes = [
      ami,
      user_data,
      instance_type
    ]
  }
}
