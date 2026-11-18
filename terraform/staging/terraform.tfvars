environment = "staging"

# Temporary names for phase 3. The live site (iuf-membership-staging.unicycling-software.com) still points at
# the EC2 ALB. The public name moves to this ALB at the cutover phase, so the plan does not touch live DNS.
domain     = "iuf-membership-staging-ecs.unicycling-software.com"
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
