output "alb_dns_name" {
  description = "ALB DNS name. Use this to smoke-test before the DNS cutover."
  value       = module.alb.alb_dns_name
}

output "acm_certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = module.alb.acm_certificate_arn
}

output "target_group_arn" {
  description = "ARN of the ECS (ip) target group"
  value       = module.alb.target_group_arn
}
