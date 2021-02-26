{
        "schemaVersion": "1.0",
        "description": "Automatic domain-join configuration created by terraform fsx repo",
        "runtimeConfig": {
           "aws:domainJoin": {
               "properties": {
                  "directoryId": "${directory_id}",
                  "directoryName": "${directory_name}",
                  "dnsIpAddresses": [ 
                     "${directory_primary_dns_ip}",
                     "${directory_secondary_dns_ip}" 
                  ]
               }
           }
        }
}