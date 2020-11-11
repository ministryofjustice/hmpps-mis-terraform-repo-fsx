# hmpps-mis-terraform-repo-fsx

##### 11th November 2020

- hmpps-mis-terraform-repo-fsx is a temporary extension to the hmpps-mis-terraform-repo for the MIS infrastructure.

This is required as the AWS FSx implementation requires Terraform 13 AWS provider for MULTI_AZ_1 deployments which we need for HA.

- hmpps-mis-terraform-repo is currently at Terraform 12 so rather than upgrade the whole repo I've moved this service out into its own repo until we upgrade to Terraform 13

**Once hmpps-mis-terraform-repo is at Terraform 13 we can migrate the active-directory folder to hmpps-mis-terraform-repo and deprecate this repo**

## Environments

**Dev**: [readme](https://github.com/ministryofjustice/hmpps-mis-terraform-repo/tree/master/docs/dev)

**Test**: [readme](https://github.com/ministryofjustice/hmpps-mis-terraform-repo/tree/master/docs/test)

**Pre-prod**: [readme](https://github.com/ministryofjustice/hmpps-mis-terraform-repo/tree/master/docs/pre-prod)

**Prod**: [readme](https://github.com/ministryofjustice/hmpps-mis-terraform-repo/tree/master/docs/prod)


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

### Jenkins file

This jenkinsfile has two parameters (not to be confused with AWS SSM Parameters)
- CONFIG_BRANCH
- DCORE_BRANCH

This has been used to specify the branch to use in place of the default `master` branch. Going forward the default will be the Git tag or branch specified in the AWS SSM Parameter Store. However the option to override will still be available for development, debugging and hotfix situations.

*psuedo code*

```
if ("aws ssm parameter version" not empty and "DCORE_BRANCH" not defaultValue)
  set "delius core version" to "aws ssm parameter version"
else
  set "delius core version" to "DCORE_BRANCH"
else
  error
```
