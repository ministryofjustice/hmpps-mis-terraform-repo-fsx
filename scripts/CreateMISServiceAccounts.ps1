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

function CreateADGroup {
    
    param (
        [string]$GroupName
    )

    write-output "---------------------------------------------------------------------------------"
    write-output "--- Creating AD Group $GroupName ---"
	
    New-ADGroup -Name $GroupName -GroupScope DomainLocal

    write-output ""

}

function AddGroupMember {

    param (
        [string]$ChildName,
        [string]$ParentGroupName
    )

    write-output "---------------------------------------------------------------------------------"
    write-output "--- Adding $ChildName to Group $ParentGroupName ---"

    #$Group = Get-ADGroup -Identity "CN=Administrators,OU=builtin,DC=delius-mis-dev,DC=local" 
    $Group = Get-ADGroup -Identity $ParentGroupName 
    Add-ADGroupMember -Identity $Group -Members $ChildName 
}



$SecureAccountPassword = "abcd1234&#&#*D"  | ConvertTo-SecureString -AsPlainText -Force

write-output '================================================================================'
write-output " Creating AD Users for Admin Team.."
write-output '================================================================================'
$GroupNames = @('hmpps-admin-users','hmpps-mis-users')

foreach ($group in $GroupNames) {
Write-Output "Creating AD group $group for Admin Team.."
   CreateADGroup $group 
   AddGroupMember $group
}



write-output '================================================================================'
write-output " Creating AD Users for Admin Team.."
write-output '================================================================================'
$AdminUsers      = @('ChrisKinsella','SteveJames')
$AdminTeamGroups = @("CN=AWS Delegated Administrators,OU=AWS Delegated Groups,DC=delius-mis-dev,DC=local")

foreach ($user in $AdminUsers) {
   
   #CreateADUser  $user $SecureAccountPassword "Admin Team"

   foreach ($group in $AdminTeamGroups) {
       AddGroupMember $user $group
   }
}

write-output '================================================================================'
write-output " Creating AD Users for MIS Team.."
write-output '================================================================================'
$MISTeamUsers  = @('RamaKotha','RaghavPalthur', 'RajuRangasamy', 'PraveenMaddini')
$MISTeamGroups = @("hmpps-mis-users")

foreach ($user in $MISTeamUsers) {
#   CreateADUser  $user $SecureAccountPassword "MIS Team"

   foreach ($group in $MISTeamGroups) {
       AddGroupMember $user $group
   }
}
