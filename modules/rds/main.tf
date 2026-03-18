terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ─────────────────────────────────────────
# DB Subnet Group
# ─────────────────────────────────────────
resource "aws_db_subnet_group" "main" {
  name       = "${var.env}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.common_tags, {
    Name = "${var.env}-db-subnet-group"
  })
}

# ─────────────────────────────────────────
# RDS Instance
# ─────────────────────────────────────────
resource "aws_db_instance" "main" {
  identifier     = "${var.env}-rds-mysql"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = var.db_instance_class

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  allocated_storage     = var.env == "prod" ? 100 : 20
  max_allocated_storage = var.env == "prod" ? 500 : 50
  storage_type          = "gp3"
  storage_encrypted     = true

  # High Availability — Multi-AZ for prod only
  multi_az = var.env == "prod" ? true : false

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_sg_id]

  backup_retention_period = var.env == "prod" ? 7 : 1
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  skip_final_snapshot       = var.env != "prod"
  final_snapshot_identifier = var.env == "prod" ? "${var.env}-final-snapshot" : null

  deletion_protection = var.env == "prod" ? true : false

  # Performance Insights for prod
  performance_insights_enabled = var.env == "prod" ? true : false

  tags = merge(var.common_tags, {
    Name = "${var.env}-rds-mysql"
  })
}
