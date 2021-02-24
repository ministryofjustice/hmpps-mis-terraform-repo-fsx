### fsx-restore-from-backup

Creates the scripts to allow restoring the FSx filesystem from the latest backup

- create-file-system-from-backup.sh.tpl -> the script to run to restore the backup to the FSx filesystem
- tags.json.tpl - the tags to apply to the FSx filesystem
- windows-configuration.json.tpl - the windows configuration to use

See https://docs.aws.amazon.com/cli/latest/reference/fsx/create-file-system-from-backup.html for details.