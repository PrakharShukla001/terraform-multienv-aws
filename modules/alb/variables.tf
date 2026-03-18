variable "env" { type = string }
variable "vpc_id" { type = string }
variable "alb_sg_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "acm_cert_arn" { type = string }
variable "aws_account_id" { type = string }
variable "common_tags" {
  type    = map(string)
  default = {}
}
