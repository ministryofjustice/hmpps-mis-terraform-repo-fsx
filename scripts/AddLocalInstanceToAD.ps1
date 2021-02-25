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
   Add-Computer -DomainName "${ad_domain_name}" -Credential $domaincreds
   Restart-Computer -Force
}
