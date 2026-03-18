variable "env" { type = string; default = "prod" }
variable "aws_region" { type = string; default = "ap-south-1" }
variable "vpc_cidr" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "azs" { type = list(string) }
variable "node_instance_type" { type = string }
variable "desired_nodes" { type = number }
variable "min_nodes" { type = number }
variable "max_nodes" { type = number }
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_password" { type = string; sensitive = true }
variable "db_instance_class" { type = string }
variable "acm_cert_arn" { type = string }
variable "aws_account_id" { type = string }
