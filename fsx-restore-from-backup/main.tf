data "template_file" "create_script" {
  template = file("./templates/create-file-system-from-backup.sh.tpl")

  vars = {
    BACKUPID             = "BACKUPID",
    CLIENTREQUESTTOKEN   = "CLIENTREQUESTTOKEN",
    PRIMARYSUBNETID      = local.preferred_subnet_id,
    SECONDARYSUBNETID    = local.secondary_subnet_id,
    SECURITYGROUPID      = local.security_group_id,
    TAGS                 = jsonencode(local.tags),
    WINDOWSCONFIGURATION = "WINDOWSCONFIGURATION",
    STORAGETYPE          = local.storage_type
  }
}

resource "null_resource" "create_script_rendered" {
  triggers = {
    json = data.template_file.create_script.rendered
  }
}

data "template_file" "tags_json" {
  template = file("./templates/tags.json.tpl")

  vars = {
    TAGS = jsonencode(local.tags)
  }
}

resource "null_resource" "tags_json" {
  triggers = {
    json = data.template_file.tags_json.rendered
  }
}

data "template_file" "windows_confguration_json" {
  template = file("./templates/windows-confguration.json.tpl")

  vars = {
    ActiveDirectoryId = local.ad_id,
    DomainName        = local.domain_name,
    OrganizationalUnitDistinguishedName = "OrganizationalUnitDistinguishedName",
    FileSystemAdministratorsGroup = "FileSystemAdministratorsGroup",
    UserName = "UserName",
    Password = "Password",
    PrimaryDNSIP = local.dns_ip_primary,
    SecondaryDNSIP = local.dns_ip_secondary,
    PreferredSubnetId  = local.preferred_subnet_id,
    ThroughputCapacity = local.throughput_capacity,
    WeeklyMaintenanceStartTime = local.weekly_maintenance_start_time,
    DailyAutomaticBackupStartTime = local.daily_automatic_backup_start_time,
    AutomaticBackupRetentionDays = local.automatic_backup_retention_days,
    Aliases = local.aliases,
    DeploymentType = local.deployment_type
  }
}

resource "null_resource" "windows_confguration_json" {
  triggers = {
    json = data.template_file.windows_confguration_json.rendered
  }
}
