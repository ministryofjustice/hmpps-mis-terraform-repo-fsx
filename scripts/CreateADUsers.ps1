function CreateADUser {
    
    param (
        [string]$ADUserName,
        [securestring]$ADUserPassword,
        [string]$TeamName
    )

    write-output "---------------------------------------------------------------------------------"
    write-output "--- Creating AD User $ADUserName ---"
	
    $AccountUserName         = "$ADUserName"
    $AccountDisplayName      = "$ADUserName $TeamName User"
    $Description             = "$TeamName User $ADUserName"
   
    New-ADUser -Name $AccountUserName -AccountPassword $ADUserPassword -DisplayName $AccountDisplayName -PasswordNeverExpires $true -Description $Description

    write-output ""

}
function AddUserToGroup {

    param (
        [string]$UserName,
        [string]$GroupName
    )

    write-output "---------------------------------------------------------------------------------"
    write-output "--- Adding User $UserName to Group $GroupName ---"


    $Group = Get-ADGroup -Identity "CN=Administrators,OU=builtin,DC=delius-mis-dev,DC=local" 
    #Add-ADGroupMember -Identity $Group -Members $UserName 
}

$SecureAccountPassword = "abcd1234&#&#*D"  | ConvertTo-SecureString -AsPlainText -Force


write-output '================================================================================'
write-output " Creating AD Users for Admin Team.."
write-output '================================================================================'
$AdminUsers      = @('ChrisKinsella','SteveJames')
$AdminTeamGroups = @('Administrators')

foreach ($user in $AdminUsers) {
   
   CreateADUser  $user $SecureAccountPassword "Admin Team"

   foreach ($group in $AdminTeamGroups) {
       AddUserToGroup $user $group
   }
}

write-output '================================================================================'
write-output " Creating AD Users for MIS Team.."
write-output '================================================================================'
$MISTeamUsers  = @('RamaKotha','RaghavPalthur', 'RajuRangasamy', 'PraveenMaddini')
$MISTeamGroups = @('Administrators')

foreach ($user in $MISTeamUsers) {
   CreateADUser  $user $SecureAccountPassword "MIS Team"

   foreach ($group in $MISTeamGroups) {
       AddUserToGroup $user $group
   }
}
