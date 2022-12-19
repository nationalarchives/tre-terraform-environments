variable "environment_name" {
  description = "Name of the environment to deploy"
  type        = string

  # validation {
  #   condition     = contains(["dev", "test", "int", "staging", "prod"], var.environment_name)
  #   error_message = "Allowed values for environment_name are \"dev\", \"int\",, \"staging\" or \"prod\"."
  # }
}

variable "prefix" {
  description = "Transformation Engine prefix"
  type        = string
  default     = "tre"
}

variable "assume_role" {
  description = "role ARNs to be assumed"
  type        = string
}

variable "external_id" {
  description = "External ID for cross account roles"
  type        = string
}

variable "tdr_sqs_retry_url" {
  description = "The TDR retry SQS Queue URL"
  type        = string
}

variable "tdr_sqs_retry_arn" {
  description = "The TDR retry SQS Queue ARN"
  type        = string
}

variable "common_version" {
  description = "(Updates if Common TRE Lambda function versions change)"
  type        = string
}

variable "common_image_versions" {
  description = "Latest version of Images for Lambda Functions"
  type = object({
    tre_slack_alerts     = string
    tre_dlq_slack_alerts = string
  })
}

variable "forward_version" {
  description = "(Updates if Common TRE Lambda function versions change)"
  type        = string
}
variable "forward_image_versions" {
  description = "Latest version of Images for Lambda Functions"
  type = object({
    tre_forward = string
  })
}

variable "vb_version" {
  description = "Validate BagIt Step Function version (update if Step Function flow or called Lambda function versions change)"
  type        = string
}

variable "vb_image_versions" {
  description = "Latest image version for Lambda Functions"
  type = object({
    tre_sqs_sf_trigger          = string
    tre_vb_validate_bagit       = string
    tre_vb_validate_bagit_files = string
  })
}

variable "dpsg_version" {
  description = "DRI Preingest SIP Generation Step Function version (update if Step Function flow or called Lambda function versions change)"
  type        = string

}

variable "dpsg_image_versions" {
  description = "Latest version of Images for Lambda Functions"
  type = object({
    tre_bagit_to_dri_sip = string
    tre_sqs_sf_trigger   = string
  })
}

# Slack Alerts

variable "slack_webhook_url" {
  description = "Webhook URL for tre slack alerts"
  type        = string
}

variable "slack_channel" {
  description = "Channel name for the tre slack alerts"
  type        = string
}

variable "slack_username" {
  description = "Username for tre slack alerts"
  type        = string
}

variable "tre_in_publishers" {
  description = "Roles that have permission to publish messages to tre-in topic"
  type        = list(string)
}

variable "tre_out_subscribers" {
  type = list(object({
    sid          = string
    subscriber   = list(string)
    endpoint_arn = list(string)
  }))
}

variable "tre_permission_boundary_arn" {
  description = "ARN of the TRE permission boundary policy"
  type        = string
}
