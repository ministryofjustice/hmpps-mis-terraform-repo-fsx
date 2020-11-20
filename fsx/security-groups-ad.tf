

# ============================================
# AD Security Group Rules
# ============================================

resource "aws_security_group_rule" "ad_egress_all_internal" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  security_group_id        = data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]
  self                     = true
  description              = "egress ALL security group internal traffic"
}

resource "aws_security_group_rule" "ad_egress_to_fsx_sg" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = aws_security_group.mis-fsx.id
  security_group_id        = data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]
  description              = "egress ALL traffic to FSx Security Group"
}

# allow inbound traffic from fsx security group 
resource "aws_security_group_rule" "ad_egress_to_fsx_integration_sg" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = local.mis_fsx_integration_security_group
  security_group_id        = data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]
  description              = "egress ALL traffic to FSx Integration Security Group"
}
