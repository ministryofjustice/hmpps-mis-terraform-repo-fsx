{
  "ActiveDirectoryId": "${ActiveDirectoryId}",
  "SelfManagedActiveDirectoryConfiguration": {
    "DomainName": "${DomainName}",
    "UserName": "${UserName}",
    "Password": "${Password}",
    "DnsIps": ["${PrimaryDNSIP}", "${SecondaryDNSIP}"]
  },
  "DeploymentType": "${DeploymentType}",
  "PreferredSubnetId": "${PreferredSubnetId}",
  "ThroughputCapacity": ${ThroughputCapacity},
  "WeeklyMaintenanceStartTime": "${WeeklyMaintenanceStartTime}",
  "DailyAutomaticBackupStartTime": "${DailyAutomaticBackupStartTime}",
  "AutomaticBackupRetentionDays": ${AutomaticBackupRetentionDays},
  "CopyTagsToBackups": true,
  "Aliases": ["${Aliases}"]
}