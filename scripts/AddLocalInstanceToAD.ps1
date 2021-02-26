# get the current domain to see if we need to add this instance to AD
$currentDomain=(Get-WmiObject win32_computersystem).Domain
Write-Host "CurrentDomain: $currentDomain"

if( $currentDomain -eq "WORKGROUP") {
  Write-Output "Current Domain is WORKGROUP so adding instance to domain"

  # Get the instance id from ec2 meta data
  $instanceid = Invoke-RestMethod "http://169.254.169.254/latest/meta-data/instance-id"

  # Get the environment name and application from this instance's tags
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

  # Get the AD Credentials to use to Add this computer to domain
  $ad_admin_username_SSMPath = "/" + $environmentName.Value + "/" + $application.Value + "/mis-activedirectory/ad/ad_admin_username"
  $ad_admin_password_SSMPath = "/" + $environmentName.Value + "/" + $application.Value + "/mis-activedirectory/ad/ad_admin_password"
  $ad_admin_username = Get-SSMParameter -Name $ad_admin_username_SSMPath -WithDecryption $true
  $ad_admin_password = Get-SSMParameter -Name $ad_admin_password_SSMPath -WithDecryption $true

  # create the secure password & credential
  $secpasswd = ConvertTo-SecureString $ad_admin_password.Value -AsPlainText -Force

  # get the domain we're adding instance to & create the credential using credentials for this domain
  $domainname="$($environmentName.Value).local"
  Write-Output "DomainName: $domainname"
  $domainusername = "${domainname}" + "\" + $ad_admin_username.Value
  Write-Output "domainusername: $domainusername"
  $domaincreds = New-Object System.Management.Automation.PSCredential ($domainusername, $secpasswd) 

  # Now add the computer to the domain & restart for the change to take effect
  Add-Computer -DomainName "${domainname}" -Credential $domaincreds
  Restart-Computer -Force
}
else {
   Write-Output "Current Domain is ${currentDomain} so looks like this instance is already added to domain"
}
