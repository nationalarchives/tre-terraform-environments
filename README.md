# tre-environments

## Deployment Workflow

The Terraform configuration in this repository is deployed automatically by
the following workflows:

* [tf-deployment.yml](.github/workflows/tf-deployment.yml)
  * [tf-plan-approve-apply.yml (in tre-github-actions repo)](https://github.com/nationalarchives/tre-github-actions/blob/main/.github/workflows/tf-plan-approve-apply.yml)

The workflow controls deployment to the various AWS environments (`dev`
through to `prod`) with various manual checkpoints along the way.

The table below shows how the workflow steps relate to both AWS target
environments and their corresponding GitHub environments
([tre-terraform-environments/settings/environments](https://github.com/nationalarchives/tre-terraform-environments/settings/environments)).
The GitHub environments are used in 2 different ways, one is to hold secret
information for an AWS environment (column "GitHub Environment"), the other is
to define a list of approval users (column "GitHub Environment for manual
check"):

| Step | AWS Environment | Step Description    | GitHub Environment | GitHub Environment for manual check |
| ---- | --------------- | ------------------- | ------------------ | ----------------------------------- |
|    1 | dev             | terraform plan      | dev                |                                     |
|    2 |                 | manual user check   |                    | apply-tf-plan-to-dev                |
|    3 | dev             | terraform apply     | dev                |                                     |
|    4 | test            | terraform plan      | test               |                                     |
|    5 |                 | manual user check   |                    | apply-tf-plan-to-test               |
|    6 | test            | terraform apply     | test               |                                     |
|    7 |                 | manual user check   |                    | deployment-checkpoint-int           |
|    8 | int             | plan                | int                |                                     |
|    9 |                 | manual user check   |                    | apply-tf-plan-to-int                |
|   10 | int             | terraform apply     | int                |                                     |
|   11 | staging         | terraform plan      | staging            |                                     |
|   12 |                 | manual user check   |                    | apply-tf-plan-to-staging            |
|   13 | staging         | terraform apply     | staging            |                                     |
|   14 |                 | manual user check   |                    | deployment-checkpoint-prod          |
|   15 | prod            | terraform plan      | prod               |                                     |
|   15 |                 | manual user check   |                    | apply-tf-plan-to-prod               |
|   16 | prod            | terraform apply     | prod               |                                     |
