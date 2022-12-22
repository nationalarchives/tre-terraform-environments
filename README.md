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

## Deployment

This project uses the S3 Terraform backend to store the Terraform state for the different TRE environments.

To start a deployment, run the [Terraform environment deployment workflow in GitHub actions][tre-tf-env-deployment] by clicking 'Run Workflow' and selecting the branch you want to use. This will run 

[tre-tf-env-deployment]: https://github.com/nationalarchives/tre-terraform-environments/actions/workflows/tf-deployment.yml

The deployment will pause when Terraform has determined which changes need to be applied. Review the Terraform plan output by clicking the link provided in the Slack notification. This will be a link to Cloudwatch in the management account so you will need to be logged in to the management AWS account to use this.

Check whether the changes look correct, then open the actions approval page and accept or reject them. To find the actions approval page, follow the link from the Slack notification:
