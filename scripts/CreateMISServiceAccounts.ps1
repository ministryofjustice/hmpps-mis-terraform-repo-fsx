Import-Module ActiveDirectory

Clear-Host

Write-Output '================================================================'
Write-Output ' Get environmentName, application variables from aws meta-data'
Write-Output '================================================================'

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
$domain_name = "$($environmentName.Value).local"

write-output '================================================================================'
write-output " Creating Service Account SVC_BOSSO-NDL"
write-output '================================================================================'

$svc_username_SSMPath = "/" + $environmentName.Value + "/" + $application.Value + "/mis-service-accounts/SVC_BOSSO-NDL/SVC_BOSSO-NDL_username"
$svc_password_SSMPath = "/" + $environmentName.Value + "/" + $application.Value + "/mis-service-accounts/SVC_BOSSO-NDL/SVC_BOSSO-NDL_password"

Write-Output "Getting the Service Username from ${svc_username_SSMPath}"
$svc_username = Get-SSMParameter -Name $svc_username_SSMPath -WithDecryption $true

Write-Output "Getting the Service Password from ${svc_password_SSMPath}"
$svc_password = Get-SSMParameter -Name $svc_password_SSMPath -WithDecryption $true

$ServiceUsername = $svc_username.Value

# netbios names limit of 15 chars so delius-auto-test has to be truncated to delius-auto-tes
# other env names are under 15 chars so not truncated
if($domainname.Length -gt 15) {
    $domainname = $domainname.SubString(0,15)
}

$OUPath = "OU=Users,OU=${domainname},DC=${domainname},DC=local"

Write-Output "Creating the user ${ServiceUsername} in '${OUPath}'"
$SecureAccountPassword = $svc_password.Value | ConvertTo-SecureString -AsPlainText -Force
New-ADUser -Name $ServiceUsername -GivenName $ServiceUsername -Surname "" -Path $OUPath -AccountPassword $SecureAccountPassword -Enabled $true

Write-Output "Checking the AD for the newly created user ${ServiceUsername}"
Get-ADUser -Filter * -Properties SamAccountName | Where { $_.samAccountName -eq $ServiceUsername }

$ServiceUsername = ""

write-output '================================================================================'
write-output " Creating Service Account SVC_DS_AD_DEV"
write-output '================================================================================'

$svc_username_SSMPath = "/" + $environmentName.Value + "/" + $application.Value + "/mis-service-accounts/SVC_DS_AD_DEV/SVC_DS_AD_DEV_username"
$svc_password_SSMPath = "/" + $environmentName.Value + "/" + $application.Value + "/mis-service-accounts/SVC_DS_AD_DEV/SVC_DS_AD_DEV_password"

Write-Output "Getting the Service Username from ${svc_username_SSMPath}"
$svc_username = Get-SSMParameter -Name $svc_username_SSMPath -WithDecryption $true

Write-Output "Getting the Service Password from ${svc_password_SSMPath}"
$svc_password = Get-SSMParameter -Name $svc_password_SSMPath -WithDecryption $true

$ServiceUsername = $svc_username.Value

$OUPath = "OU=Users,OU=${domainname},DC=${domainname},DC=local"
Write-Output "Creating the user ${ServiceUsername} in '${OUPath}'"
$SecureAccountPassword = $svc_password.Value | ConvertTo-SecureString -AsPlainText -Force
New-ADUser -Name $ServiceUsername -GivenName $ServiceUsername -Surname "" -Path $OUPath -AccountPassword $SecureAccountPassword -Enabled $true


Write-Output "Checking the AD for the newly created user ${ServiceUsername}"
Get-ADUser -Filter * -Properties SamAccountName | Where { $_.samAccountName -eq $ServiceUsername }

$ServiceUsername = ""

write-output '================================================================================'
write-output " Creating Service Account SVC_DFI_NDL"
write-output '================================================================================'

$svc_username_SSMPath = "/" + $environmentName.Value + "/" + $application.Value + "/mis-service-accounts/SVC_DFI_NDL/SVC_DFI_NDL_username"
$svc_password_SSMPath = "/" + $environmentName.Value + "/" + $application.Value + "/mis-service-accounts/SVC_DFI_NDL/SVC_DFI_NDL_password"

Write-Output "Getting the Service Username from ${svc_username_SSMPath}"
$svc_username = Get-SSMParameter -Name $svc_username_SSMPath -WithDecryption $true

Write-Output "Getting the Service Password from ${svc_password_SSMPath}"
$svc_password = Get-SSMParameter -Name $svc_password_SSMPath -WithDecryption $true

$ServiceUsername = $svc_username.Value

# netbios names limit of 15 chars so delius-auto-test has to be truncated to delius-auto-tes
# other env names are under 15 chars so not truncated
if($domainname.Length -gt 15) {
    $domainname = $domainname.SubString(0,15)
}

$OUPath = "OU=Users,OU=${domainname},DC=${domainname},DC=local"

Write-Output "Creating the user ${ServiceUsername} in '${OUPath}'"
$SecureAccountPassword = $svc_password.Value | ConvertTo-SecureString -AsPlainText -Force
New-ADUser -Name $ServiceUsername -GivenName $ServiceUsername -Surname "" -Path $OUPath -AccountPassword $SecureAccountPassword -Enabled $true

Write-Output "Checking the AD for the newly created user ${ServiceUsername}"
Get-ADUser -Filter * -Properties samAccountName | Where { $_.samAccountName -eq $ServiceUsername }