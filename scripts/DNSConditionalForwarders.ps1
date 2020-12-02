

# https://docs.microsoft.com/en-us/powershell/module/dnsserver/add-dnsserverconditionalforwarderzone?view=winserver2012r2-ps

$ADDNSServerIP  = "10.162.35.251"
$R53DNSServerIP = "10.162.32.2"

$domainname    = "delius-mis-dev.internal" 
Add-DnsServerConditionalForwarderZone -ComputerName $ADDNSServerIP -Name "$domainname" -ReplicationScope "Domain" -MasterServers $R53DNSServerIP

$domainname    = "ecs.cluster" 
Add-DnsServerConditionalForwarderZone -ComputerName $ADDNSServerIP -Name "$domainname" -ReplicationScope "Domain" -MasterServers $R53DNSServerIP

$domainname    = "mis-dev.delius.probation.hmpps.dsd.io" 
Add-DnsServerConditionalForwarderZone -ComputerName $ADDNSServerIP -Name "$domainname" -ReplicationScope "Domain" -MasterServers $R53DNSServerIP

$domainname    = "mis-dev.probation.service.justice.gov.uk" 
Add-DnsServerConditionalForwarderZone -ComputerName $ADDNSServerIP -Name "$domainname" -ReplicationScope "Domain" -MasterServers $R53DNSServerIP

Get-DnsServerForwarder -ComputerName $ADDNSServerIP


write-output '================================================================================'
write-output 'DNS Conditional Forwarder Settings after update'
write-output '================================================================================'

Get-DnsServerZone -ComputerName  $ADDNSServerIP | Where { $_.ZoneType -eq 'Forwarder'} | ft * 


write-output '================================================================================'
write-output " Checking DNS Conditional Forwarders.."
write-output '================================================================================'

$dnslookups = @('delius-db-1.delius-mis-dev.internal','usermanagement.ecs.cluster','ndl-bws-101.mis-dev.delius.probation.hmpps.dsd.io','password-reset.mis-dev.probation.service.justice.gov.uk')

$dnslookups.ForEach({
    write-output "---------------------------------------------------------------------------------"
    write-output "--- Checking DNS Conditional Forwarders for $_ ---"
	Resolve-DnsName -Name $_
    write-output ""
})
