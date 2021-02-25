
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_endpoint
resource "aws_route53_resolver_endpoint" "resolve_local_entries_using_ad_dns" {
  
  name      = "ForwardDotLocalDNSLookupsToADDNSServersTF"
  direction = "OUTBOUND"

  security_group_ids = [ 
      local.mis_ad_security_group_id
  ]
  
  ip_address {
    subnet_id = local.private_subnet_ids[0]
  }

  ip_address {
    subnet_id = local.private_subnet_ids[1]
  }

  tags = local.tags
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule
resource "aws_route53_resolver_rule" "r53_fwd_to_ad" {
  domain_name          = "${local.environment_name}.local"
  name                 = "${local.environment_name}-local"
  rule_type            = "FORWARD"
  
  resolver_endpoint_id = aws_route53_resolver_endpoint.resolve_local_entries_using_ad_dns.id

  target_ip {
    ip = local.ad_dns_ip_1
  }

  target_ip {
    ip = local.ad_dns_ip_2
  }

  tags = local.tags
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association
resource "aws_route53_resolver_rule_association" "vpc_r53_fwd_to_ad" {
  resolver_rule_id = aws_route53_resolver_rule.r53_fwd_to_ad.id
  vpc_id           = local.vpc_id
}