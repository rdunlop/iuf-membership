environment = "prod"

# Temporary names for the first prod plan, so live DNS is not touched. At cutover these become
# domain = "iuf-membership.unicycling-software.com" (the live public name) and alb_domain stays the same.
domain     = "iuf-membership-ecs.unicycling-software.com"
alb_domain = "iuf-membership-alb.unicycling-software.com"

zone_id = "Z1NYSHL8JOE6MN"
vpc_id  = "vpc-2fba5746"

# 1a and 1b, same as staging. The live EC2 instance is in 1a.
subnet_ids = ["subnet-964aa4ff", "subnet-26dfd65e"]

# Shared dbaccess security group on the shared RDS instance (unisofteurope)
rds_security_group_id = "sg-0489281f76adb8987"

ecr_repository_url = "197931692346.dkr.ecr.eu-central-1.amazonaws.com/iuf-membership"

# TO CONFIRM against the production server's .env.local before the first deploy.
paypal_mode     = "live"
rollbar_env     = "production"
currency        = "EUR"
membership_cost = "15"
