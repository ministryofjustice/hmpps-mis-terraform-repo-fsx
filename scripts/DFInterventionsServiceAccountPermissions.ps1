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
$domainName = $environmentName.Value

#============================================================
# Getting FSx FileSystem Powershell Endpoint via AWS Powershell
#============================================================
$FileSystem = Get-FsxFileSystem | ? {$_.Tags.Key -eq "Name" -and $_.Tags.Value -eq "mis-bfs"}
#$FileSystem
$FileSystemId = $FileSystem.FileSystemId
Write-Output "FileSystemId: $FileSystemId"
$WindowsConfiguration = $FileSystem.WindowsConfiguration
$WindowsConfiguration
$Tags = $FileSystem.Tags
$Tags | ft *
$Endpoint = $FileSystem.WindowsConfiguration.RemoteAdministrationEndpoint
Write-Output "Powershell Endpoint: $Endpoint"

#============================================================
# Open a session to the target FSx Powershell endpoint 
#============================================================
$Session = New-PSSession -ComputerName $Endpoint -ConfigurationName FSxRemoteAdmin     

Import-PsSession $Session -AllowClobber
$Session

#============================================================
# The following commands run in the context of the Imported 
# Session so are actually being run on the target FSx instance 
#============================================================

# Get the FSx Share details
Get-FSxSmbShare -Name 'dfinterventions'

# Get the File Share Permissions
Get-FSxSmbShareAccess -Name 'dfinterventions'

# now grant permissions on the share
# Syntax same as https://docs.microsoft.coma/en-us/powershell/module/smbshare/grant-smbshareaccess?view=win10-ps

# NT AUTHORITY\SYSTEM - MANDATORY permission
Grant-FSxSmbShareAccess -Name 'dfinterventions' -AccountName 'NT AUTHORITY\SYSTEM' -AccessRight Full -Force

# delius-mis-dev\AWS Delegated Administrators
Grant-FSxSmbShareAccess -Name 'dfinterventions' -AccountName "${domainName}\AWS Delegated Administrators"  -AccessRight Full -Force

# delius-mis-dev\SVC_DFI_NDL
Grant-FSxSmbShareAccess -Name 'dfinterventions' -AccountName "${domainName}\SVC_DFI_NDL" -AccessRight Full -Force

# everyone
Revoke-FSxSmbShareAccess -Name 'dfinterventions' -AccountName 'everyone' -Force

# Get the File Share Permissions
Get-FSxSmbShareAccess -Name 'dfinterventions'

#============================================================
# Disconnect remote session
#============================================================
Disconnect-PsSession $Session
$Session
