environment = "staging"

# Cutover: the public name points at the new ECS ALB. The old EC2 ALB keeps running until we retire it,
# so rolling back means pointing the public name at the old ALB again.
domain     = "iuf-membership-staging.unicycling-software.com"
alb_domain = "iuf-membership-staging-alb.unicycling-software.com"

zone_id = "Z1NYSHL8JOE6MN"
vpc_id  = "vpc-2fba5746"

# 1a and 1b (approved). The live EC2 instances are in 1a.
subnet_ids = ["subnet-964aa4ff", "subnet-26dfd65e"]

# Shared dbaccess security group on the shared RDS instance (unisofteurope)
rds_security_group_id = "sg-0489281f76adb8987"

ecr_repository_url = "197931692346.dkr.ecr.eu-central-1.amazonaws.com/iuf-membership"

# Values to confirm against the server's .env.local before the first deploy.
paypal_mode     = "test"
rollbar_env     = "staging"
currency        = "EUR"
membership_cost = "15"
