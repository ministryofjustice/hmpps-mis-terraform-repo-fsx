# show commands for Fsx
# Get-Command -Module FSxRemoteAdmin

# https://docs.aws.amazon.com/fsx/latest/WindowsGuide/remote-pwrshell.html
# https://www.youtube.com/watch?v=vbnk4Ov9gL0

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

$domainName = $EnvironmentName
#============================================================
# Getting FSx FileSystem Powershell Endpoint via AWS Powershell
#============================================================
$FileSystem = Get-FsxFileSystem | ? {$_.Tags.Key -eq "Name" -and $_.Tags.Value -eq "mis-bfs"}
$Endpoint = $FileSystem.WindowsConfiguration.RemoteAdministrationEndpoint
Write-Output "Powershell Endpoint: $Endpoint"

Write-Output "#============================================================"
Write-Output "# Lookup SVC_BOSSO-NDL Service Account UserName from SSM"
Write-Output "#============================================================"
$svc_bosso_username_SSMPath = "/" + $EnvironmentName + "/" + $ApplicationName + "/mis-service-accounts/SVC_BOSSO-NDL/SVC_BOSSO-NDL_username"
$svc_bosso_username_SSMPath
$svc_bosso_username         = Get-SSMParameter -Name $svc_bosso_username_SSMPath -WithDecryption $true
$SVC_BOSSO_NDL_Username     = $svc_bosso_username.Value
Write-Output "SVC_BOSSO_NDL_Username: '$SVC_BOSSO_NDL_Username'"

Write-Output "#============================================================"
Write-Output "# Lookup SVC_DS_AD_DEV Service Account UserName from SSM"
Write-Output "#============================================================"
$svc_ds_username_SSMPath = "/" + $EnvironmentName + "/" + $ApplicationName + "/mis-service-accounts/SVC_DS_AD_DEV/SVC_DS_AD_DEV_username"
$svc_ds_username_SSMPath
$svc_ds_username        = Get-SSMParameter -Name $svc_ds_username_SSMPath -WithDecryption $true
$SVC_DS_AD_DEV_Username = $svc_ds_username.Value
Write-Output "SVC_DS_AD_DEV_UserName: '$SVC_DS_AD_DEV_UserName'"

#============================================================
# Open a session to the target FSx Powershell endpoint 
#============================================================
$Session = New-PSSession -ComputerName $Endpoint -ConfigurationName FSxRemoteAdmin     

Import-PsSession $Session -AllowClobber
$Session

#============================================================
# Note: The following commands run in the context of the 
# imported session so are actually being run on the target 
# FSx instance 
#============================================================

# Get the FSx Share details
Get-FSxSmbShare -Name 'share'

# Get the File Share Permissions
Get-FSxSmbShareAccess -Name 'share'

# now grant permissions on the share
# Syntax same as https://docs.microsoft.com/en-us/powershell/module/smbshare/grant-smbshareaccess?view=win10-ps

# NT AUTHORITY\SYSTEM - MANDATORY permission
Grant-FSxSmbShareAccess -Name 'share' -AccountName 'NT AUTHORITY\SYSTEM' -AccessRight Full -Force

# delius-mis-dev\AWS Delegated Administrators
Grant-FSxSmbShareAccess -Name 'share' -AccountName "${domainName}\AWS Delegated Administrators"  -AccessRight Full -Force

# delius-mis-dev\SVC_DS_AD_DEV
Grant-FSxSmbShareAccess -Name 'share' -AccountName "${domainName}\${SVC_DS_AD_DEV_UserName}" -AccessRight Full -Force

# delius-mis-dev\SVC_BOSSO-NDL
Grant-FSxSmbShareAccess -Name 'share' -AccountName "${domainName}\${SVC_BOSSO_NDL_Username}" -AccessRight Full -Force

# everyone
Revoke-FSxSmbShareAccess -Name 'share' -AccountName 'everyone' -Force

#============================================================
# Disconnect remote session
#============================================================
Disconnect-PsSession $Session
$Session
