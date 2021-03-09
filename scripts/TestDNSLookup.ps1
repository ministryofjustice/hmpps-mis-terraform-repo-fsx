Clear-Host

Write-Output '================================================================'
Write-Output ' Get environmentName, environment variables from aws meta-data'
Write-Output '================================================================'

# Get the instance id from ec2 meta data
$instanceid = Invoke-RestMethod "http://169.254.169.254/latest/meta-data/instance-id"

# Get the environment name and application from this instance's environment-name and application tag values
$environment = Get-EC2Tag -Filter @(
        @{
            name="resource-id"
            values="$instanceid"
        }
        @{
            name="key"
            values="environment"
        }
    )
$environmentName = Get-EC2Tag -Filter @(
        @{
            name="resource-id"
            values="$instanceid"
        }
        @{
            name="key"
            values="environment-name"
        }
    )

$shortenv = $environment.Value
$envname  = $environmentName.Value


Write-Output '================================================================'
Write-Output 'Testing DNS lookup for ecs.cluster'
Write-Output '================================================================'
#Resolve-DnsName -Name delius-gdpr-api.ecs.cluster
Resolve-DnsName -Name delius-gdpr-ui.ecs.cluster
Resolve-DnsName -Name delius-aptracker-api.ecs.cluster
Resolve-DnsName -Name password-reset.ecs.cluster
Resolve-DnsName -Name usermanagement.ecs.cluster

Write-Output '================================================================'
Write-Output "Testing DNS lookup for ${envname}.internal"
Write-Output '================================================================'
Resolve-DnsName -Name "delius-db-1.${envname}.internal"
Resolve-DnsName -Name "mis-db-1.${envname}.internal"
Resolve-DnsName -Name "misboe-db-1.${envname}.internal"
Resolve-DnsName -Name "misdsd-db-1.${envname}.internal"
Resolve-DnsName -Name "ndl-bcs-801.${envname}.internal"
Resolve-DnsName -Name "ndl-bfs-801.${envname}.internal"
Resolve-DnsName -Name "ndl-bps-801.${envname}.internal"
Resolve-DnsName -Name "ndl-bws-801.${envname}.internal"
Resolve-DnsName -Name "ndl-dis-801.${envname}.internal"

Write-Output '================================================================'
Write-Output "Testing DNS lookup for ${envname}.internal"
Write-Output '================================================================'
Resolve-DnsName -Name "delius-db-1.${envname}.internal"
Resolve-DnsName -Name "mis-db-1.${envname}.internal"
Resolve-DnsName -Name "misboe-db-1.${envname}.internal"
Resolve-DnsName -Name "misdsd-db-1.${envname}.internal"
Resolve-DnsName -Name "ndl-bcs-801.${envname}.internal"
Resolve-DnsName -Name "ndl-bfs-801.${envname}.internal"
Resolve-DnsName -Name "ndl-bps-801.${envname}.internal"
Resolve-DnsName -Name "ndl-bws-801.${envname}.internal"
Resolve-DnsName -Name "ndl-dis-801.${envname}.internal"

Write-Output '================================================================'
Write-Output "Testing DNS lookup for ${shortenv}.delius.probation.hmpps.dsd.io"
Write-Output '================================================================'
Resolve-DnsName -Name "delius-db-1.${shortenv}.delius.probation.hmpps.dsd.io"
Resolve-DnsName -Name "misboe-db-1.${shortenv}.delius.probation.hmpps.dsd.io"
Resolve-DnsName -Name "misdsd-db-1.${shortenv}.delius.probation.hmpps.dsd.io"
Resolve-DnsName -Name "mis-db-1.${shortenv}.delius.probation.hmpps.dsd.io"

Write-Output '================================================================'
Write-Output "Testing DNS lookup for ${shortenv}.probation.service.justice.gov.uk"
Write-Output '================================================================'
Resolve-DnsName -Name "ndelius.${shortenv}.probation.service.justice.gov.uk"
Resolve-DnsName -Name "password-reset.${shortenv}.probation.service.justice.gov.uk"

Write-Output '================================================================'
Write-Output "Testing DNS lookup for ${shortenv}.local"
Write-Output '================================================================'
Resolve-DnsName -Name "ndl-bcs-801.${envname}.local"
Resolve-DnsName -Name "ndl-bfs-801.${envname}.local"
Resolve-DnsName -Name "ndl-bps-801.${envname}.local"
Resolve-DnsName -Name "ndl-bws-801.${envname}.local"
Resolve-DnsName -Name "ndl-dis-801.${envname}.local"
Resolve-DnsName -Name "ndl-adm-801.${envname}.local"
Resolve-DnsName -Name "ndl-adm-802.${envname}.local"
