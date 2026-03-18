# ─────────────────────────────────────────
# STAGING Environment — Close to prod, medium resources
# ─────────────────────────────────────────

env        = "staging"
aws_region = "ap-south-1"

# VPC
vpc_cidr        = "10.1.0.0/16"
public_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnets = ["10.1.3.0/24", "10.1.4.0/24"]
azs             = ["ap-south-1a", "ap-south-1b"]

# EKS — Medium size
node_instance_type = "t3.medium"
desired_nodes      = 2
min_nodes          = 1
max_nodes          = 4

# RDS — Medium
db_name           = "stagingapp"
db_username       = "admin"
db_password       = "Staging@123456"
db_instance_class = "db.t3.small"

# ALB + SSL
acm_cert_arn   = "arn:aws:acm:ap-south-1:ACCOUNT_ID:certificate/CERT_ID"
aws_account_id = "YOUR_AWS_ACCOUNT_ID"
