

#######################################
# SECURITY GROUPS
#  see https://docs.aws.amazon.com/fsx/latest/WindowsGuide/fsx-aws-managed-ad.html
#######################################

resource "aws_security_group" "mis-fsx" {
  name        = "${local.common_name}-fsx"
  description = "security group for ${local.common_name}-fsx instances to fsx filesystem"
  vpc_id      = local.vpc_id

  # internal traffic
  ingress {
    description = "ingress internal security group traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = true
  }

  egress {
    description = "egress internal security group traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = true
  }

  # DNS 
  egress {
    description = "DNS egresss to tcp/53"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "DNS egresss to udp/53"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # # allow egress to AD Domain Controllers -  TCP 88, 135,389, 445, 464, 636, 3268, 9389, 49152-65535
  egress {
    description     = "egress TCP/88 Kerberos authentication"
    from_port       = 88
    to_port         = 88
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]]
  }

  egress {
    description     = "egress tcp/135 DCE / EPMAP"
    from_port       = 135
    to_port         = 135
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]]
  }

  egress {
    description     = "egress tcp/389 Lightweight Directory Access Protocol (LDAP)"
    from_port       = 389
    to_port         = 389
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]]
  }

  egress {
    description     = "egress tcp/445 Directory Services SMB file sharing"
    from_port       = 445
    to_port         = 445
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]]
  }

  egress {
    description     = "egress tcp/464 Change/Set password"
    from_port       = 464
    to_port         = 464
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]]
  }

  egress {
    description     = "Active Directory egress tcp/636 Directory Services SMB file sharing"
    from_port       = 636
    to_port         = 636
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]]
  }

  egress {
    description     = "egress tcp/3268 Microsoft Global Catalog"
    from_port       = 3268
    to_port         = 3268
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]]
  }

  egress {
    description     = "egress tcp/3269 Microsoft Global Catalog over SSL"
    from_port       = 3269
    to_port         = 3269
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]]
  }

  egress {
    description     = "egress tcp/5985 WinRM 2.0"
    from_port       = 5985
    to_port         = 5985
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]]
  }

  egress {
    description     = "egress tcp/9389 Microsoft AD DS Web Services, PowerShell"
    from_port       = 9389
    to_port         = 9389
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]]
  }

  egress {
    description     = "egress tcp/49152-65535 Ephemeral ports for RPC"
    from_port       = 49152
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]]
  }


  # # allow egress to AD Domain Controllers -  UDP 88.123.389,464

  egress {
    description     = "Active Directory egress UDP 88 Kerberos"
    from_port       = 88
    to_port         = 88
    protocol        = "udp"
    security_groups = [data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]]
  }

  egress {
    description     = "Active Directory egress UDP 123 NTP"
    from_port       = 123
    to_port         = 123
    protocol        = "udp"
    security_groups = [data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]]
  }

  egress {
    description     = "Active Directory egress UDP 389"
    from_port       = 389
    to_port         = 389
    protocol        = "udp"
    security_groups = [data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]]
  }

  egress {
    description     = "Active Directory egress UDP 464"
    from_port       = 464
    to_port         = 464
    protocol        = "udp"
    security_groups = [data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]]
  }

  tags = merge(
    local.tags,
    {
      "Name" = "${local.common_name}-fsx"
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

# allow traffic from fsx security group to AD Security Group
resource "aws_security_group_rule" "fsx_egress_to_ad_sg" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = aws_security_group.mis-fsx.id
  security_group_id        = data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]
  description              = "FSx traffic to Active Directory egress"
}

# allow inbound traffic from fsx security group 
resource "aws_security_group_rule" "ad_ingress_from_fsx_sg" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = aws_security_group.mis-fsx.id
  security_group_id        = data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]
  description              = "Allow ingress from FSx Security Group to AD Security Group"
}

