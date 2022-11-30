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

variable "assume_role" {
  description = "role ARNs to be assumed"
  type        = string
}

variable "external_id" {
  description = "External ID for cross account roles"
  type        = string
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "tre_forward_lambda_role" {
  name               = "${var.env}-${var.prefix}-forward-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

