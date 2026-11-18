variable "environment" {
  type        = string
  description = "Environment name (prod or staging)"

  validation {
    condition     = contains(["prod", "staging"], var.environment)
    error_message = "environment must be prod or staging"
  }
}

variable "domain" {
  type        = string
  description = "Name the app is served on. The module creates a CNAME from here to alb_domain and an ACM certificate for it."
}

variable "alb_domain" {
  type        = string
  description = "Name the new ALB serves. Gets an A (alias) record to the ALB."
}

variable "zone_id" {
  type        = string
  description = "Route53 hosted zone ID"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the ALB and ECS tasks"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Public subnets for the ALB and Fargate tasks. At least 2, in different AZs."
}

variable "rds_security_group_id" {
  type        = string
  description = "Security group of the shared RDS instance (dbaccess). The ECS tasks get a port 5432 ingress rule."
}

variable "ecr_repository_url" {
  type        = string
  description = "ECR repository URL without a tag, from terraform/global output ecr_repository_url"
}

variable "image_tag" {
  type        = string
  description = "Image tag to deploy. Not set in tfvars: bin/tf supplies the tag of the image currently running in ECS (or IMAGE_TAG)."
}

variable "paypal_mode" {
  type        = string
  description = "PAYPAL_MODE for the app: test or live"
}

variable "rollbar_env" {
  type        = string
  description = "ROLLBAR_ENV, so errors are reported under the right environment"
}

variable "currency" {
  type        = string
  description = "CURRENCY for the app, e.g. EUR"
}

variable "membership_cost" {
  type        = string
  description = "MEMBERSHIP_COST for the app"
}
