# ─────────────────────────────────────────
# PROD Environment — High availability, max resources
# ─────────────────────────────────────────
aws_account_id = "397161558687"
env        = "prod"
aws_region = "ap-south-1"

# VPC — Separate CIDR from dev/staging
vpc_cidr        = "10.2.0.0/16"
public_subnets  = ["10.2.1.0/24", "10.2.2.0/24"]
private_subnets = ["10.2.3.0/24", "10.2.4.0/24"]
azs             = ["ap-south-1a", "ap-south-1b"]

# EKS — Large, HA setup
node_instance_type = "t3.large"
desired_nodes      = 3
min_nodes          = 2
max_nodes          = 10

# RDS — Multi-AZ, large instance
db_name           = "prodapp"
db_username       = "admin"
db_password       = "Prod@SecurePass123!"   # Use AWS Secrets Manager!
db_instance_class = "db.t3.medium"

# ALB + SSL
acm_cert_arn   = "arn:aws:acm:ap-south-1:ACCOUNT_ID:certificate/CERT_ID"
aws_account_id = "YOUR_AWS_ACCOUNT_ID"
