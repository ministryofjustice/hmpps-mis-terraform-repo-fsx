# https://docs.microsoft.com/en-us/powershell/module/dnsserver/add-dnsserverconditionalforwarderzone?view=winserver2012r2-ps
Write-Output '================================================================'
Write-Output ' Get environmentName, application variables from aws meta-data'
Write-Output '================================================================'

# Get the instance id from ec2 meta data
$instanceid = Invoke-RestMethod "http://169.254.169.254/latest/meta-data/instance-id"

# Get the environment name and application from this instance's environment-name and application tag values
$environmentNameTag = Get-EC2Tag -Filter @(
        @{
            name="resource-id"
            values="$instanceid"
        }
        @{
            name="key"
            values="environment-name"
        }
    )
$EnvironmentName = $environmentNameTag.Value
Write-Output "EnvironmentName: $EnvironmentName"

$environmentTag = Get-EC2Tag -Filter @(
        @{
            name="resource-id"
            values="$instanceid"
        }
        @{
            name="key"
            values="environment"
        }
    )
$Environment = $environmentTag.Value
Write-Output "Environment: $Environment"

Write-Output '================================================================'
Write-Output ' Get DNS Server 1st IP for ActiveDirectory'
Write-Output '================================================================'
$Directory = Get-DsDirectory
$Directory

$DNSIPAddrs = $Directory.DnsIpAddrs
Write-Output "DNSIPAddrs: $DNSIPAddrs"

$DNSIPAddr1 = $DNSIPAddrs[0]
Write-Output "DNSIPAddr1: $DNSIPAddr1"

$ADDNSServerIP  = $DNSIPAddr1 #"10.162.35.251"

Write-Output '================================================================'
Write-Output ' Get VPC DNS Server to forward DNS queries to Route53'
Write-Output '================================================================'
$VPCEC2DhcpOption = Get-EC2DhcpOption | ? {$_.Tags.Key -eq "Name" -and $_.Tags.Value -eq "${EnvironmentName}-dhcp-options"}
$VPCDomainNameServers = $VPCEC2DhcpOption.DhcpConfigurations | Where {$_.Key -eq "domain-name-servers"}
$VPCDNSServer = $VPCDomainNameServers.Value
Write-Output "VPCDNSServer: $VPCDNSServer"

$R53DNSServerIP = $VPCDNSServer

$domainname = "${EnvironmentName}.internal"
Add-DnsServerConditionalForwarderZone -ComputerName $ADDNSServerIP -Name "$domainname" -ReplicationScope "Domain" -MasterServers $R53DNSServerIP

$domainname = "ecs.cluster" 
Add-DnsServerConditionalForwarderZone -ComputerName $ADDNSServerIP -Name "$domainname" -ReplicationScope "Domain" -MasterServers $R53DNSServerIP

$domainname = "${Environment}.delius.probation.hmpps.dsd.io" 
Add-DnsServerConditionalForwarderZone -ComputerName $ADDNSServerIP -Name "$domainname" -ReplicationScope "Domain" -MasterServers $R53DNSServerIP

$domainname = "${Environment}.probation.service.justice.gov.uk" 
Add-DnsServerConditionalForwarderZone -ComputerName $ADDNSServerIP -Name "$domainname" -ReplicationScope "Domain" -MasterServers $R53DNSServerIP

Get-DnsServerForwarder -ComputerName $ADDNSServerIP


write-output '================================================================================'
write-output 'DNS Conditional Forwarder Settings after update'
write-output '================================================================================'

Get-DnsServerZone -ComputerName  $ADDNSServerIP | Where { $_.ZoneType -eq 'Forwarder'} | ft * 


write-output '================================================================================'
write-output " Checking DNS Conditional Forwarders.."
write-output '================================================================================'

$dnslookups = @("delius-db-1.${EnvironmentName}.internal","usermanagement.ecs.cluster","ndl-bws-101.${Environment}.delius.probation.hmpps.dsd.io","password-reset.${Environment}.probation.service.justice.gov.uk")

$dnslookups.ForEach({
    write-output "---------------------------------------------------------------------------------"
    write-output "--- Checking DNS Conditional Forwarders for $_ ---"
	Resolve-DnsName -Name $_
    write-output ""
})
