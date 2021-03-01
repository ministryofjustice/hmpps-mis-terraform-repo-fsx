
output "awsconfig_Domain_document" {
  value = {
    name             = aws_ssm_document.awsconfig_domain_document.name
    created_date     = aws_ssm_document.awsconfig_domain_document.created_date
    description      = aws_ssm_document.awsconfig_domain_document.description
    schema_version   = aws_ssm_document.awsconfig_domain_document.schema_version
    default_version  = aws_ssm_document.awsconfig_domain_document.default_version
    document_version = aws_ssm_document.awsconfig_domain_document.document_version
    hash             = aws_ssm_document.awsconfig_domain_document.hash
    hash_type        = aws_ssm_document.awsconfig_domain_document.hash_type
    latest_version   = aws_ssm_document.awsconfig_domain_document.latest_version
    owner            = aws_ssm_document.awsconfig_domain_document.owner
    status           = aws_ssm_document.awsconfig_domain_document.status
    parameter        = aws_ssm_document.awsconfig_domain_document.parameter
    platform_types   = aws_ssm_document.awsconfig_domain_document.platform_types
  }
}