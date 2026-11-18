# iuf-membership infrastructure, built from the shared modules in unicycling-infra.
# Pinned to a tag: bump the ref deliberately, then check the plan before applying.

module "alb" {
  source = "git::https://github.com/rdunlop/unicycling-infra.git//modules/alb-ingress?ref=v0.4.0"

  app_name          = "iuf-membership"
  environment       = var.environment
  vpc_id            = var.vpc_id
  subnet_ids        = var.subnet_ids
  zone_id           = var.zone_id
  domain            = var.domain
  alb_domain        = var.alb_domain
  subject_alt_names = []
  wildcard_domain   = null

  # EC2 is still serving the live site. The new ALB has no EC2 target until the cutover phase.
  legacy_ec2 = null

  ecs_target_group_name = "iuf-membership-${var.environment}-ecs"
  ecs_port              = 3000
  ecs_health_check_path = "/healthcheck"
}

module "ecs_app" {
  source = "git::https://github.com/rdunlop/unicycling-infra.git//modules/ecs-app?ref=v0.4.0"

  app_name                   = "iuf-membership"
  environment                = var.environment
  region                     = "eu-central-1"
  vpc_id                     = var.vpc_id
  subnet_ids                 = var.subnet_ids
  alb_security_group_id      = module.alb.alb_security_group_id
  target_group_arn           = module.alb.target_group_arn
  database_security_group_id = var.rds_security_group_id
  # The app does not use the shared ElastiCache cluster.
  redis_security_group_id = null
  ecr_repository_url      = var.ecr_repository_url
  image_tag               = var.image_tag

  web_port   = 3000
  web_cpu    = 512
  web_memory = 1024

  # No Sidekiq worker. Its resources are not created.
  sidekiq_enabled = false
  sidekiq_cpu     = 256
  sidekiq_memory  = 512

  container_insights = var.environment == "staging" ? "disabled" : "enabled"

  environment_vars = [
    { name = "RAILS_ENV", value = "production" },
    { name = "PORT", value = "3000" },
    { name = "RAILS_MAX_THREADS", value = "5" },
    { name = "RAILS_LOG_LEVEL", value = "info" },
    # The app's SES mail region. unicycling-software.com is verified with production access in eu-west-1 (EU).
    # The ECS cluster itself stays in eu-central-1.
    { name = "AWS_REGION", value = "eu-west-1" },
    { name = "SERVER_HOSTNAME", value = var.domain },
    { name = "PAYPAL_MODE", value = var.paypal_mode },
    { name = "ROLLBAR_ENV", value = var.rollbar_env },
    { name = "CURRENCY", value = var.currency },
    { name = "MEMBERSHIP_COST", value = var.membership_cost },
  ]

  # SSM SecureString parameters under /iuf-membership/<environment>/. Create them before scaling the service up.
  # Basic auth is staging only. Prod does not use it.
  secret_names = concat(
    [
      "SECRET_KEY_BASE",
      "DATABASE_HOST", "DATABASE_NAME", "DATABASE_USERNAME", "DATABASE_PASSWORD",
      "PAYPAL_CLIENT_ID", "PAYPAL_SECRET",
      "AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY",
      "EMAIL_FROM",
      "ROLLBAR_ACCESS_TOKEN", "ROLLBAR_CLIENT_ACCESS_TOKEN",
    ],
    var.environment == "staging" ? ["BASIC_AUTH_USERNAME", "BASIC_AUTH_PASSWORD"] : [],
  )
}
