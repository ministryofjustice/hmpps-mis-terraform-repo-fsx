Clear-Host

function New-RandomPassword {
    param(
        [Parameter()]
        [int]$MinimumPasswordLength = 5,
        [Parameter()]
        [int]$MaximumPasswordLength = 10,
        [Parameter()]
        [int]$NumberOfAlphaNumericCharacters = 5,
        [Parameter()]
        [switch]$ConvertToSecureString
    )

    Add-Type -AssemblyName 'System.Web'
    $length = Get-Random -Minimum $MinimumPasswordLength -Maximum $MaximumPasswordLength
    $password = [System.Web.Security.Membership]::GeneratePassword($length,$NumberOfAlphaNumericCharacters)
    if ($ConvertToSecureString.IsPresent) {
        ConvertTo-SecureString -String $password -AsPlainText -Force
    } else {
        $password
    }
}

function CreateADUser {

    param (
        [string]$ADUserName,
        [securestring]$ADUserPassword,
        [string]$TeamName
    )

    try {
         $User = Get-ADUser -Identity $ADUserName
	     #$User
         write-output "--- User $ADUserName already exists ---"
    }
    catch {
        write-output "---------------------------------------------------------------------------------"
        write-output "--- Creating AD User $ADUserName ---"

        $AccountUserName    = "$ADUserName"
        $AccountDisplayName = "$ADUserName $TeamName User"
        $Description        = "$TeamName User $ADUserName"

        New-ADUser -Name $AccountUserName -AccountPassword $ADUserPassword -DisplayName $AccountDisplayName -PasswordNeverExpires $true -Description $Description
        write-output ""
    }
}

function AddGroupMember {

    param (
        [string]$UserName,
        [string]$GroupName
    )

    try {
        $Group = Get-ADGroup -Identity $GroupName
        write-output "---------------------------------------------------------------------------------"
        write-output "--- Adding $UserName to Group '$GroupName' ---"

        Add-ADGroupMember -Identity $Group -Members $UserName

        write-output ""
    }
    catch {
        Write-Output "Group $GroupName doesn't exist so can't add user to group"
    }
}

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
$domainname = $environmentName.Value
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

# OU Suffixes
$OUUsersPathSuffix=",OU=Users,OU=${domainname},DC=${domainname},DC=local"

# Admin Users
$AdminUsers      = @('SteveJames','EddieNyambudzi','DonNyambudzi','ZakHamed','RanbeerSingh','AdrianWeetman','SebNorris','PiotrGrzeskowiak')
$AdminTeamGroups = @("CN=AWS Delegated Administrators,OU=AWS Delegated Groups,DC=${domainname},DC=local")

# MIS Team Users
$MISTeamUsers  = @('RamaKotha','RaghavPalthur', 'RajuRangasamy', 'PraveenMaddini')
$MISTeamGroups = @("CN=AWS Delegated Administrators,OU=AWS Delegated Groups,DC=${domainname},DC=local")

#TODO:// Add default password to SSM Parameter Store to set for users
#$SecureAccountPassword = "abcd1234&#&#*D"  | ConvertTo-SecureString -AsPlainText -Force

write-output '================================================================================'
write-output " Creating AD Admin Users and Adding to AD Domain Groups in ${domainname}.local"
write-output '================================================================================'


foreach ($user in $AdminUsers) {

   $OUUserPath="CN=${user}${OUUsersPathSuffix}"
   $OUUserPath

   $SecureAccountPassword = New-RandomPassword -MinimumPasswordLength 10 -MaximumPasswordLength 15 -NumberOfAlphaNumericCharacters 6 -ConvertToSecureString

   CreateADUser $user $SecureAccountPassword "Admin Team"

   foreach ($group in $AdminTeamGroups) {
      Write-Output "Adding User '$user' to group '$AdminTeamGroups'"
      AddGroupMember $user $group
   }
   Write-Output "Enabling user account ${user}"
   Enable-ADAccount -Identity $user
}

write-output '================================================================================'
write-output " Creating AD MIS Users and Adding to AD Domain Groups."
write-output '================================================================================'

foreach ($user in $MISTeamUsers) {
   CreateADUser  $user $SecureAccountPassword "MIS Team"

   foreach ($group in $MISTeamGroups) {
       Write-Output "Adding User '$user' to group '$group'"
       AddGroupMember $user $group
   }
   Write-Output "Enabling user account ${user}"
   Enable-ADAccount -Identity $user
}
