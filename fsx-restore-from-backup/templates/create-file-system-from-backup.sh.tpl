create-file-system-from-backup \
    --backup-id ${BACKUPID}
    --client-request-token ${CLIENTREQUESTTOKEN}
    --subnet-ids ${PRIMARYSUBNETID} ${SECONDARYSUBNETID}
    --security-group-ids ${SECURITYGROUPID}
    --tags ${TAGS}
    --windows-configuration ${WINDOWSCONFIGURATION}
    --storage-type ${STORAGETYPE}
    --cli-input-json ''
    