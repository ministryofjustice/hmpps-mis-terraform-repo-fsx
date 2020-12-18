
function SetServiceAccountCredentials {
    
    param (
        [string]$ServiceName,
        [string]$ServiceDescription,
        [string]$EnvironmentName,
        [string]$ApplicationName,
        [string]$ServiceAccountName
    )

    Write-Output '====================================================='
    Write-Output " Service: ${ServiceName} - ${ServiceDescription}"
    Write-Output '====================================================='
    
    $svc_username_SSMPath = "/" + $EnvironmentName + "/" + $ApplicationName + "/mis-service-accounts/${ServiceAccountName}/${ServiceAccountName}_username"
    $svc_username_SSMPath
    $svc_password_SSMPath = "/" + $EnvironmentName + "/" + $ApplicationName + "/mis-service-accounts/${ServiceAccountName}/${ServiceAccountName}_password"
    $svc_password_SSMPath
    
    $svc_username       = Get-SSMParameter -Name $svc_username_SSMPath -WithDecryption $true
    $svc_password       = Get-SSMParameter -Name $svc_password_SSMPath -WithDecryption $true
    $decryptedPassword  = $svc_password.Value
    $svc_username_full  = "${domain_name}" + "\" + $svc_username.Value
    
    Write-Output "Stopping Service '${ServiceName}' with new credentials"
    Stop-Service -Name $ServiceName -PassThru

    Write-Output "Setting Service '$ServiceName' to RunAs '$svc_username_full'"
    
    $svc_Obj= Get-WmiObject Win32_Service -filter "name='$ServiceName'"
    
    $ChangeStatus = $svc_Obj.change($null,$null,$null,$null,$null,
                          $null, $svc_username_full, "${decryptedPassword}" ,$null,$null,$null)
    If ($ChangeStatus.ReturnValue -eq "0") {
        Write-host "RunAs set sucessfully for the service '$Service' in $env:COMPUTERNAME"
    } 

    Write-Output "Starting Service '${ServiceName}' with new credentials"
    Start-Service -Name $ServiceName -PassThru

}

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

Write-Output '====================================================='
Write-Output ' Set Services to run as Domain Service Accounts'
Write-Output '====================================================='

$hostname_suffix = ($env:COMPUTERNAME).Substring(0,7)

Write-Output "Hostname suffix is ${hostname_suffix}"
switch($hostname_suffix){
   'ndl-bcs' {
        SetServiceAccountCredentials -ServiceName 'BOEXI40SIACMSTIER101' -ServiceDescription 'Server Intelligence Agent (CMSTIER101)' -EnvironmentName $environmentName.Value -ApplicationName $application.Value -ServiceAccountName 'SVC_BOSSO-NDL'
   }
   'ndl-bps' {
        SetServiceAccountCredentials -ServiceName 'BOEXI40SIAPROCTIER101' -ServiceDescription 'Server Intelligence Agent (PROCTIER101)' -EnvironmentName $environmentName.Value -ApplicationName $application.Value -ServiceAccountName 'SVC_BOSSO-NDL'
   }
   'ndl-dis' {
        SetServiceAccountCredentials -ServiceName 'DI_JOBSERVICE' -ServiceDescription 'SAP Data Services' -EnvironmentName $environmentName.Value -ApplicationName $application.Value -ServiceAccountName 'SVC_DS_AD_DEV'
        SetServiceAccountCredentials -ServiceName 'BOEXI40SIANDLDIS101' -ServiceDescription 'Server Intelligence Agent (NDLDIS101)' -EnvironmentName $environmentName.Value -ApplicationName $application.Value -ServiceAccountName 'SVC_DS_AD_DEV'
   }
}
