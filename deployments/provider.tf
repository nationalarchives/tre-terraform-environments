provider "aws" {
  region = "eu-west-2"
  assume_role {
    role_arn = var.assume_role
    external_id = var.external_id
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
