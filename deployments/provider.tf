provider "aws" {
  region = "eu-west-2"
  assume_role {
    role_arn    = var.assume_role
    external_id = var.external_id
  }
  default_tags {
    tags = {
      Environment     = var.environment_name
      Owner           = "digital-archiving"
      Terraform       = true
      TerraformSource = "https://github.com/nationalarchives/tre-terraform-environments"
      CostCentre      = "56"
      Role            = "prvt"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
  }
}
