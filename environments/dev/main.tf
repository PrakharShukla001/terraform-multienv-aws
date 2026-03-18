terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state — S3 backend
  backend "s3" {
    bucket         = "prakhar-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "dev"
      ManagedBy   = "Terraform"
      Owner       = "Prakhar-Shukla"
      Project     = "multienv-infra"
    }
  }
}

# ─────────────────────────────────────────
# Common Tags
# ─────────────────────────────────────────
locals {
  common_tags = {
    Environment = var.env
    ManagedBy   = "Terraform"
    Owner       = "Prakhar-Shukla"
    Project     = "multienv-infra"
  }
}

# ─────────────────────────────────────────
# VPC Module
# ─────────────────────────────────────────
module "vpc" {
  source          = "../../modules/vpc"
  env             = var.env
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
  common_tags     = local.common_tags
}

# ─────────────────────────────────────────
# Security Groups Module
# ─────────────────────────────────────────
module "security_groups" {
  source      = "../../modules/security-groups"
  env         = var.env
  vpc_id      = module.vpc.vpc_id
  common_tags = local.common_tags
}

# ─────────────────────────────────────────
# EKS Module
# ─────────────────────────────────────────
module "eks" {
  source             = "../../modules/eks"
  env                = var.env
  private_subnet_ids = module.vpc.private_subnet_ids
  cluster_sg_id      = module.security_groups.eks_cluster_sg_id
  node_instance_type = var.node_instance_type
  desired_nodes      = var.desired_nodes
  min_nodes          = var.min_nodes
  max_nodes          = var.max_nodes
  common_tags        = local.common_tags
}

# ─────────────────────────────────────────
# RDS Module
# ─────────────────────────────────────────
module "rds" {
  source             = "../../modules/rds"
  env                = var.env
  private_subnet_ids = module.vpc.private_subnet_ids
  db_sg_id           = module.security_groups.rds_sg_id
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  db_instance_class  = var.db_instance_class
  common_tags        = local.common_tags
}
