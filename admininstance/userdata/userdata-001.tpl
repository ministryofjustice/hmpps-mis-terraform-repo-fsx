<powershell>

# Install Chocolatey & Carbon
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ChocoInstallPath = "$env:SystemDrive\ProgramData\Chocolatey\bin"
$ErrorActionPreference = "Stop"
$VerbosePreference="Continue"

if (!(Test-Path $ChocoInstallPath)) {
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}
choco install carbon -y --version 2.9.2

Import-Module Carbon

Invoke-WebRequest https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe -OutFile $env:USERPROFILE\Desktop\SSMAgent_latest.exe
Start-Process -FilePath $env:USERPROFILE\Desktop\SSMAgent_latest.exe -ArgumentList "/S"

$misCreds = New-Credential -UserName "${user}" -Password "${password}"
Install-User -Credential $misCreds
Add-GroupMember -Name Administrators -Member ${user}

$bossoCreds = New-Credential -UserName "${bosso_user}" -Password "${bosso_password}"
Install-User -Credential $bossoCreds
Add-GroupMember -Name Administrators -Member ${bosso_user}

$ComputerName = "${host_name}"

Remove-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "Hostname"
Remove-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "NV Hostname"

New-PSDrive -name HKU -PSProvider "Registry" -Root "HKEY_USERS"

Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Computername\Computername" -name "Computername" -value $ComputerName
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Computername\ActiveComputername" -name "Computername" -value $ComputerName
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "Hostname" -value $ComputerName
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "NV Hostname" -value  $ComputerName
Set-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -name "AltDefaultDomainName" -value $ComputerName
Set-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -name "DefaultDomainName" -value $ComputerName

$MaxSize = (Get-PartitionSupportedSize -DriveLetter C).sizeMax
Resize-Partition -DriveLetter C -Size $MaxSize

# Install AD Client and DNS Client Tools
Install-WindowsFeature RSAT-ADDS
Install-WindowsFeature RSAT-DNS-Server

# set DNS servers to AD servers so we can find FSx DNS entries
$serverAddresses = Get-DNSClientServerAddress -InterfaceAlias Ether* -AddressFamily IPv4
$ad_dns_ip_1="${ad_dns_ip_1}"
$ad_dns_ip_2="${ad_dns_ip_2}"
Set-DNSClientServerAddress -interfaceIndex $serverAddresses.InterfaceIndex -ServerAddresses ("$ad_dns_ip_1", "$ad_dns_ip_2")

# Get the instance id from ec2 meta data
$instanceid = Invoke-RestMethod "http://169.254.169.254/latest/meta-data/instance-id"

# Get the environment name and application from this instance's environment-name and application tag values
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
$application = Get-EC2Tag -Filter @(
        @{
            name="resource-id"
            values="$instanceid"
        }
        @{
            name="key"
            values="application"
        }
    )

Write-Output "environmentName: $($environmentName.Value)"
Write-Output "application:     $($application.Value)"

$ad_admin_username_SSMPath = "/" + $environmentName.Value + "/" + $application.Value + "/mis-activedirectory/ad/ad_admin_username"
$ad_admin_password_SSMPath = "/" + $environmentName.Value + "/" + $application.Value + "/mis-activedirectory/ad/ad_admin_password"
$ad_admin_username = Get-SSMParameter -Name $ad_admin_username_SSMPath -WithDecryption $true
$ad_admin_password = Get-SSMParameter -Name $ad_admin_password_SSMPath -WithDecryption $true
$secpasswd = ConvertTo-SecureString $ad_admin_password.Value -AsPlainText -Force

$domainusername = "${ad_domain_name}" + "\" + $ad_admin_username.Value
$domainusername
$domaincreds = New-Object System.Management.Automation.PSCredential ($domainusername, $secpasswd) 

# Now add the computer to the domain if its not already in the domain
$domain=(Get-WmiObject win32_computersystem).Domain
Write-Host $domain

if( $domain -eq "WORKGROUP") {
    Try {
        write-host "Adding Computer to AD"
        Add-Computer -DomainName "${ad_domain_name}" -Credential $domaincreds
    }
    Catch {
        # show any errors, will error if no AD Account found for Computer
        $_
        #if computer is in AD we remove it.
        #Get-ADComputer -Identity $env:COMPUTERNAME -Credential $domaincreds | Remove-ADComputer

        $ldapfilter= "(name=*" + $env:ComputerName + "*)"
        write-host "ldapfilter: $ldapfilter"

        $searchbase = "OU=Computers,OU=" + $environmentName.Value + ",DC=" + $environmentName.Value + ",DC=internal"
        write-host "searchbase: $searchbase"

        Get-ADComputer -LDAPFilter "$ldapfilter" -SearchBase "$searchbase" -Server ${ad_dns_ip_1} -Credential $domaincreds 

    }
    Finally {
        #Restart-Computer -Force
    } 
}

# Now map the FSx filesystem (as we're now on the domain)
# Windows 2016 Allows global mapping as 
# see https://medium.com/@bberkayilmaz/mounting-aws-fsx-with-autoscaling-in-terraform-eee3d115d49c - scenario 3
#New-SmbGlobalMapping -RemotePath "\\${bfs_filesystem_dns_name}\share" -Persistent $true -Credential $domaincreds -LocalPath D:
#Get-SmbGlobalMapping 

</powershell>
<persist>true</persist>