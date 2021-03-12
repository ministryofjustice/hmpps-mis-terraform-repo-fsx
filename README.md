# hmpps-mis-terraform-repo-fsx

##### 11th November 2020

- hmpps-mis-terraform-repo-fsx is a temporary extension to the hmpps-mis-terraform-repo for the MIS infrastructure.

This is required as the AWS FSx implementation requires Terraform 13 AWS provider for MULTI_AZ_1 deployments which we need for HA.

- hmpps-mis-terraform-repo is currently at Terraform 12 so rather than upgrade the whole repo I've moved this service out into its own repo until we upgrade to Terraform 13

**Once hmpps-mis-terraform-repo is at Terraform 13 we can migrate the component folders to hmpps-mis-terraform-repo and deprecate this repo**

- activedirectory - Creates the *.{environment_name}.local AD
- fsx - creates the AWS FSx FileSystem
- admininstance - Creates a utility Windows 2016 Admin Instance 
- dns - creates AWS Route53 DNS Resolver to allow *.internal hosts to resolve *.local DNS entries for the AD added instances


## Environments

**delius-mis-dev**: [readme](https://github.com/ministryofjustice/hmpps-mis-terraform-repo/tree/master/docs/dev)

**delius-auto-dev**: [readme](https://github.com/ministryofjustice/hmpps-mis-terraform-repo/tree/master/docs/test)

**delius-stage**: [readme](https://github.com/ministryofjustice/hmpps-mis-terraform-repo/tree/master/docs/stage)

**delius-pre-prod**: [readme](https://github.com/ministryofjustice/hmpps-mis-terraform-repo/tree/master/docs/pre-prod)

**delius-prod**: [readme](https://github.com/ministryofjustice/hmpps-mis-terraform-repo/tree/master/docs/prod)





## GitHub Actions

An action to delete the branch after merge has been added.
Also an action that will tag when branch is merged to master
See https://github.com/anothrNick/github-tag-action

```
Bumping

Manual Bumping: Any commit message that includes #major, #minor, or #patch will trigger the respective version bump. If two or more are present, the highest-ranking one will take precedence.

Automatic Bumping: If no #major, #minor or #patch tag is contained in the commit messages, it will bump whichever DEFAULT_BUMP is set to (which is minor by default).

Note: This action will not bump the tag if the HEAD commit has already been tagged.
```

## Release / Deployments

The new process will include the addition of deploying a known version of this code using a tag from the git repo.
After the code is tested, code reviewed the merge of the feature branch to master will trigger the GitHub action resulting in git tag creation.
These tags can be progressed through the environments towards Production by specifying the tag to deploy.

The tag value is retrieved from AWS SSM Parameter Store. See https://github.com/ministryofjustice/delius-versions
The version retrieved from the AWS SSM Parameter Store is set by updating the tag value in the map `hmpps-delius-core-terraform` in `config/020-delius-core.tfvars` for the environment.

### Deployment

#### Notes: 
- FSx requires Terraform 0.13 or above
- Remember to update ENVIRONMENT in each command :o)

#### 1. ActiveDirectory
```
export TF_VAR_ad_admin_password=$$$ValueFromSSMParameterStore$$$

ENVIRONMENT=delius-auto-test CONTAINER=mojdigitalstudio/hmpps-terraform-builder-0-13 COMPONENT=activedirectory tg plan

ENVIRONMENT=delius-auto-test CONTAINER=mojdigitalstudio/hmpps-terraform-builder-0-13 COMPONENT=activedirectory tg apply
```

#### 2. FSx Filesystem
```
ENVIRONMENT=delius-auto-test CONTAINER=mojdigitalstudio/hmpps-terraform-builder-0-13 COMPONENT=fsx tg plan

ENVIRONMENT=delius-auto-test CONTAINER=mojdigitalstudio/hmpps-terraform-builder-0-13 COMPONENT=fsx tg apply
```

#### 3. ssm document to allow auto AD Join for Windows instances
```
ENVIRONMENT=delius-auto-test CONTAINER=mojdigitalstudio/hmpps-terraform-builder-0-13 COMPONENT=ssm tg plan
```

#### 4. DNS - Create Route53 Resolvers to allow non AD Joined instances to resolve AD joined *.local instances using the AD DNS Servers
```
ENVIRONMENT=delius-auto-test CONTAINER=mojdigitalstudio/hmpps-terraform-builder-0-13 COMPONENT=dns tg plan

ENVIRONMENT=delius-auto-test CONTAINER=mojdigitalstudio/hmpps-terraform-builder-0-13 COMPONENT=dns tg apply
```

#### 5. Create the Admin Instances
```
ENVIRONMENT=delius-auto-test CONTAINER=mojdigitalstudio/hmpps-terraform-builder-0-13 COMPONENT=admininstance tg plan

ENVIRONMENT=delius-auto-test CONTAINER=mojdigitalstudio/hmpps-terraform-builder-0-13 COMPONENT=admininstance tg apply

```

#### 6. Create the FSx Alarms & Dashboards
```
ENVIRONMENT=delius-auto-test CONTAINER=mojdigitalstudio/hmpps-terraform-builder-0-13 COMPONENT=monitoring-fsx tg plan

ENVIRONMENT=delius-auto-test CONTAINER=mojdigitalstudio/hmpps-terraform-builder-0-13 COMPONENT=monitoring-fsx tg apply
```