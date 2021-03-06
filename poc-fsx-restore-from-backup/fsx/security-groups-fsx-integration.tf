
# ============================================
# FSx Integration Security Group
# ============================================
resource "aws_security_group_rule" "fsx_integration_sg_ingress_from_fsx_sg" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = aws_security_group.mis-fsx.id
  security_group_id        = local.mis_fsx_integration_security_group
  description              = "ingress ALL traffic from FSx Security Group"
}

resource "aws_security_group_rule" "fsx_integration_sg_egress_to_fsx_sg" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = aws_security_group.mis-fsx.id
  security_group_id        = local.mis_fsx_integration_security_group
  description              = "egress ALL traffic to FSx Security Group"
}

resource "aws_security_group_rule" "fsx_integration_sg_ingress_from_ad_sg" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]
  security_group_id        = local.mis_fsx_integration_security_group
  description              = "ingress ALL traffic from AD Security Group"
}

resource "aws_security_group_rule" "fsx_integration_sg_egress_to_ad_sg" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = data.terraform_remote_state.activedirectory.outputs.mis_ad["security_group_id"]
  security_group_id        = local.mis_fsx_integration_security_group
  description              = "egress ALL traffic to AD Security Group"
}
