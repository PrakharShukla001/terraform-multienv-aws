# ─────────────────────────────────────────
# DEV Environment — Minimal resources, low cost
# ─────────────────────────────────────────

env        = "dev"
aws_region = "ap-south-1"

# VPC
vpc_cidr        = "10.0.0.0/16"
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
azs             = ["ap-south-1a", "ap-south-1b"]

# EKS — Smallest for dev
node_instance_type = "t3.small"
desired_nodes      = 1
min_nodes          = 1
max_nodes          = 2

# RDS — Smallest for dev
db_name           = "devapp"
db_username       = "admin"
db_password       = "Dev@123456"        # Use AWS Secrets Manager in real project!
db_instance_class = "db.t3.micro"
