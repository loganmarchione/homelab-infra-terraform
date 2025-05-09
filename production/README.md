# production

## Explanation

Repo containing Terraform files that are currently being used, aka "production".

## Requirements

### AWS

* The AWS account was already created
* The `Administrators` group was [already created](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html) with the `AdministratorAccess` policy.
* Access to billing has been [granted to IAM users](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/control-access-billing.html#ControllingAccessWebsite-Activate).
* The non-root users `logan` and `terraform`:
  * Are already created in the console (`logan` has console and CLI access, `terraform` has CLI-only access)
  * Are already members of the `Administrators` group
  * Already have their access keys recorded
  * AWS CLI is already setup

After setup is complete, do the following:

* Record access keys for the `acme` user
  ```
  terraform output acme_username
  terraform output acme_password
  ```
* Record the SMTP username and password for the `postfixrelay` user
  ```
  terraform output postfixrelay_username
  terraform output postfixrelay_password
  ```

## DigitalOcean

* An API key is already generated

## Cloudflare

* An API token is already generated

## Usage

```
terraform plan -var-file=secrets.tfvars
```

## Things you'll need to do manually (the functionality isn't in Terraform)
