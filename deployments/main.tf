# Common
module "common" {
  source                      = "../modules/common"
  env                         = var.environment_name
  prefix                      = var.prefix
  account_id                  = data.aws_caller_identity.aws.account_id
  tre_permission_boundary_arn = var.tre_permission_boundary_arn
  common_version              = var.common_version
  common_image_versions       = var.common_image_versions
  tre_slack_alerts_publishers = [
    module.dri_preingest_sip_generation.dri_preingest_sip_generation_role_arn,
    module.validate_bagit.validate_bagit_role_arn
  ]
  tre_data_bucket_write_access = [
    module.dri_preingest_sip_generation.dri_preingest_sip_generation_lambda_role,
    module.validate_bagit.validate_bagit_lambda_invoke_role
  ]
  slack_webhook_url    = var.slack_webhook_url
  slack_channel        = var.slack_channel
  slack_username       = var.slack_username
  tre_in_publishers    = var.tre_in_publishers
  tre_in_subscriptions = local.tre_in_subscriptions
  tre_internal_publishers = [
    module.validate_bagit.validate_bagit_role_arn,
    module.dri_preingest_sip_generation.dri_preingest_sip_generation_role_arn
  ]
  tre_internal_subscriptions = local.tre_internal_subscriptions
  tre_out_publishers = [
    module.validate_bagit.validate_bagit_role_arn,
    module.dri_preingest_sip_generation.dri_preingest_sip_generation_role_arn,
    module.forward.tre_forward_lambda_arn
  ]
  tre_out_subscriptions = local.tre_out_subscriptions
  tre_out_subscribers   = var.tre_out_subscribers
  ecr_uri_host          = var.ecr_uri_host
  ecr_uri_repo_prefix   = var.ecr_uri_repo_prefix
}

# TRE Forward
module "forward" {
  source                              = "../modules/tre-forward"
  env                                 = var.environment_name
  prefix                              = var.prefix
  account_id                          = data.aws_caller_identity.aws.account_id
  tre_permission_boundary_arn         = var.tre_permission_boundary_arn
  tre_out_topic_arn                   = module.common.common_tre_out_topic_arn
  tre_dlq_alerts_lambda_function_name = module.common.tre_dlq_alerts_lambda_function_name
  forward_version                     = var.forward_version
  forward_image_versions              = var.forward_image_versions
  ecr_uri_host                        = var.ecr_uri_host
  ecr_uri_repo_prefix                 = var.ecr_uri_repo_prefix
}

# Validate BagIt
module "validate_bagit" {
  source                              = "../modules/step-functions/validate-bag"
  env                                 = var.environment_name
  prefix                              = var.prefix
  tre_permission_boundary_arn         = var.tre_permission_boundary_arn
  tre_data_bucket                     = module.common.common_tre_data_bucket
  vb_image_versions                   = var.vb_image_versions
  vb_version                          = var.vb_version
  common_tre_slack_alerts_topic_arn   = module.common.common_tre_slack_alerts_topic_arn
  common_tre_internal_topic_arn       = module.common.common_tre_internal_topic_arn
  tre_dlq_alerts_lambda_function_name = module.common.tre_dlq_alerts_lambda_function_name
  ecr_uri_host                        = var.ecr_uri_host
  ecr_uri_repo_prefix                 = var.ecr_uri_repo_prefix
}

# DRI Preigest SIP Generation
module "dri_preingest_sip_generation" {
  source                              = "../modules/step-functions/dri-preingest-sip-generation"
  env                                 = var.environment_name
  prefix                              = var.prefix
  account_id                          = data.aws_caller_identity.aws.account_id
  tre_permission_boundary_arn         = var.tre_permission_boundary_arn
  common_tre_slack_alerts_topic_arn   = module.common.common_tre_slack_alerts_topic_arn
  dpsg_image_versions                 = var.dpsg_image_versions
  dpsg_version                        = var.dpsg_version
  common_tre_internal_topic_arn       = module.common.common_tre_internal_topic_arn
  tre_dlq_alerts_lambda_function_name = module.common.tre_dlq_alerts_lambda_function_name
  ecr_uri_host                        = var.ecr_uri_host
  ecr_uri_repo_prefix                 = var.ecr_uri_repo_prefix
}
