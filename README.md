# TRE Terraform Environments

## Introduction
This repository contains the Terraform code to create AWS resources needed to support TRE

## Terraform Structure
The prototype is divided into separate Terraform modules that represent the different AWS resources that are needed for TRE.

The different modules are used by Terraform workspaces which represent five AWS environments:

* dev
* test
* int
* staging
* prod

## GitHub Actions

[tf-deployment.yml](tf-deployment.yml) is run manually which uses a [reusable workflow](https://docs.github.com/en/actions/using-workflows/reusing-workflows) called [tf-plan-approve-apply.yml](https://github.com/nationalarchives/tre-github-actions/blob/main/.github/workflows/tf-plan-approve-apply.yml).

### Secrets

Following Secrets are used by the workflow 

* Environment
    * **ROLE_ARN:** ARNs of the AWS IAM Roles created in AWS TRE Management Account for granting access to GitHub Actions using OpenID Connect
* Repository
    * **AWS_PARAM_STORE_TF_BACKEND_KEY:** Name of the AWS Parameter Store where the terraform environments backend settings are stored
    * **SLACK_TOKEN:** Slack Webhook URL used to send notifications

## Deployment

This project uses the S3 Terraform backend to store the Terraform state for the different TRE environments.

To start a deployment:

Go the Actions tab -> Click [Terraform environment deployment] -> Click "Run workflow" -> select the branch with the workflow file you want to use -> Click the green "Run worklfow" button

[Terraform environment deployment]: https://github.com/nationalarchives/tre-terraform-environments/actions/workflows/tf-deployment.yml

The deployment will pause when Terraform has determined which changes need to be applied. Review the Terraform plan output by clicking the link provided in the Slack notification. This will be a link to Cloudwatch in the management account so you will need to be logged in to the management AWS account to use this.

Check whether the changes look correct, then open the actions approval page and accept or reject them. To find the actions approval page, follow the link from the Slack notification.

## Local development

### Install Terraform locally

See: https://learn.hashicorp.com/terraform/getting-started/install.html

### Install AWS CLI Locally

See: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html

### Add AWS Credentials and Profiles

1. Update local AWS credentials file (~/.aws/credentials) with a user's credentials for the TDR AWS management account:

   ```
   ... other credentials ...

   [tre-aws]
   aws_access_key_id = ... terraform user access key ...
   aws_secret_access_key = ... terraform user secret access key ...
   ```

## Running Terraform Project Locally
> **Warning**
>
> Running Terraform locally should only be used to check the Terraform plan. Updating the TRE environments should only ever be done through GitHub Actions

1. Clone [TRE Environments project](https://github.com/nationalarchives/tre-terraform-environments) to local machine

2. In command terminal navigate to the folder where the project has been cloned to

4. Clone Terraform modules repositories.
   
   ```
   [location of project] $ git clone git@github.com:nationalarchives/tre-tf-module-common.git

   [location of project] $ git@github.com:nationalarchives/tre-tf-module-tre-forward.git

   [location of project] $ git@github.com:nationalarchives/tre-tf-module-dpsg.git

   [location of project] $ git@github.com:nationalarchives/tre-tf-module-validate-bag.git
   ```

5. Initialize Terraform:
* Create a file with terraform backend config

    ```
    [location of project] $ cd deployments
    [location of project] $ nano backend.conf

    external_id = ""
    bucket = ""
    key = ""
    region = ""
    dynamodb_table = ""
    encrypt = true
    ```
   ```
   [location of project] $ terraform init 
   ```

6. Create Terraform workspaces corresponding to the TRE environments:

> **Warning**
>
> terraform workspace creation required locally prior to deploying with GitHub Actions

   ```
   [location of project] $ terraform workspace new dev

   [location of project] $ terraform workspace new test

   [location of project] $ terraform workspace new int

   [location of project] $ terraform workspace new staging

   [location of project] $ terraform workspace new prod
   ```
7. Switch to the Terraform workspace corresponding to the TDR environment to be worked on:

   ```
   [location of project] $ terraform workspace select dev
   ```

8. Run the following command to ensure Terraform uses the correct credentials:

   ```
   [location of project] $ export AWS_PROFILE=tre-aws
   ```

9. Run Terraform to view changes that will be made to the TRE environment AWS resources

   ```
   [location of project] $ terraform plan
   ```
10. Run `terraform fmt --recursive` to properly format your Terraform changes

11. Before you push the changes made in terraform-environments directory, if you've made changes to a sub-module, push and get those changes
merged (`cd modules/{sub-module name}`) and then update the sub-module hashes (instructions on how to do this are below) before moving onto the next step.


## Updating sub-module hashes

To update the hashes for the sub-modules, following an update to them:

1. On the command line go to the sub-module directory in the tdr-terraform-environment directory

   ```
   [location of project] $ cd modules/common
   ```
   Or
   ```
   [location of project] $ cd modules/tre-forward
   ```
   ```
   [location of project] $ cd modules/step-functions/dri-preingest-sip-generation
   ```
   ```
   [location of project] $ cd modules/step-functions/validate-bag
   ```
2. Ensure you are on the Git main branch for the sub-module   
3. Pull the latest main branch for the sub-module

   ```
   [location of sub-module] $ git pull
   ```

4. Go back to the main tre-terraform-environments directory

5. Check that the sub-module is now showing as a change

   ```
   [location of project] $ git status
   ```

6. Commit and merge the sub-module change as any other normal change to the code


## Further Information

* Terraform website: https://www.terraform.io/
* Terraform basic tutorial: https://learn.hashicorp.com/terraform/getting-started/build
