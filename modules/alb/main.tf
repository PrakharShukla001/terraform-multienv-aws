terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ─────────────────────────────────────────
# Application Load Balancer
# ─────────────────────────────────────────
resource "aws_lb" "main" {
  name               = "${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.env == "prod" ? true : false

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.bucket
    prefix  = "${var.env}-alb"
    enabled = true
  }

  tags = merge(var.common_tags, {
    Name = "${var.env}-alb"
  })
}

# ─────────────────────────────────────────
# Target Group
# ─────────────────────────────────────────
resource "aws_lb_target_group" "main" {
  name     = "${var.env}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/health"
    matcher             = "200"
  }

  tags = merge(var.common_tags, {
    Name = "${var.env}-target-group"
  })
}

# ─────────────────────────────────────────
# HTTP Listener (redirect to HTTPS)
# ─────────────────────────────────────────
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# ─────────────────────────────────────────
# HTTPS Listener
# ─────────────────────────────────────────
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.acm_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# ─────────────────────────────────────────
# S3 Bucket for ALB Logs
# ─────────────────────────────────────────
resource "aws_s3_bucket" "alb_logs" {
  bucket        = "${var.env}-alb-access-logs-${var.aws_account_id}"
  force_destroy = var.env != "prod"

  tags = merge(var.common_tags, {
    Name = "${var.env}-alb-logs"
  })
}

resource "aws_s3_bucket_lifecycle_configuration" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  rule {
    id     = "expire-old-logs"
    status = "Enabled"
    expiration {
      days = var.env == "prod" ? 90 : 30
    }
    filter {}
  }
}
