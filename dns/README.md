### DNS

This folder creates a Route53 resolver to allow  instances not in the Active Direcrory Domain (*.{environment_name}.internal) resolve *.local DNS entries for the AD added MIS Windows Instances

- When we add an instance to the AD domain its hostname is then 

```
{name}.{environment_name}.local
```


- Non AD added instances are on

```
{name}.{environment_name}.internal
```



