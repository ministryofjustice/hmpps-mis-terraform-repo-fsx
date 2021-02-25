Install-WindowsFeature RSAT-AD-PowerShell
Install-WindowsFeature RSAT-DNS-Server

Import-Module DNSServer

$ErrorActionPreference = "Stop"
$VerbosePreference = "Continue"

try {

    $instanceid = Invoke-RestMethod "http://169.254.169.254/latest/meta-data/instance-id"

    $region      =  Get-EC2Tag -Filter @(
        @{
            name="resource-id"
            values="$instanceid"
        }
        @{
            name="key"
            values="region"
        }
    )

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

    $PrivateIP = ((Get-EC2Instance -Region $region.Value).Instances | ?{$_.InstanceId -eq $instanceid}).PrivateIpAddress
    if (!$PrivateIP)  {
        Write-Host('Error - Failed to retrieve Private IP for this instance')
        Exit 1
    }
    
    write-output '============================================================================='
    write-output ' Set DNS entry in AD ie. ndl-bcs-001.delius-mis-dev.local'
    write-output '============================================================================='
    Set-Location ENV:
    
    $domainName=(Get-WmiObject win32_computersystem).Domain
    Write-Host $domainName

    if (!$domainName)  {
        Write-Host('Error - Failed to domainName name for instance')
        Exit 1
    }
    
    $hostname = $env:computername.ToLower()
    Write-Host $hostname

    $ZoneName  = ((Get-WmiObject Win32_ComputerSystem).Domain)
    Write-Output "ZoneName: $ZoneName"

    $DnsServerComputerName = (Resolve-DnsName $ZoneName -Type NS)[0].NameHost

    # check if we already have a CName (yes we should in this case) & remove, add it
    $ARecord = Get-DnsServerResourceRecord -ComputerName $DnsServerComputerName -Name $hostname -ZoneName $ZoneName
    Write-Output $ARecord

    if($ARecord -ne $null) {
        Write-Output "Removing DNS A Record for '$hostname' on DNSServer '$DnsServerComputerName'"
        Remove-DnsServerResourceRecord -Name $hostname -RRType "A" -ComputerName $DnsServerComputerName -ZoneName $ZoneName -Force
    }

    Write-Output "Adding DNS A Record for '$hostname' on DNS Server '$DnsServerComputerName' for IPv4Address '$PrivateIP'"
    Add-DnsServerResourceRecordA -Name $hostname -ComputerName $DnsServerComputerName -IPv4Address $PrivateIP -ZoneName $ZoneName -TimeToLive 01:00:00 -AgeRecord
      
}
catch [Exception] {
    Write-Host ('Failed to Update AD DNS')
    echo $_.Exception|format-list -force
    #exit 1
}