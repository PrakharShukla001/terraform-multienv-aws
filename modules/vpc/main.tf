terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ─────────────────────────────────────────
# VPC
# ─────────────────────────────────────────
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.common_tags, {
    Name = "${var.env}-vpc"
  })
}

# ─────────────────────────────────────────
# Internet Gateway
# ─────────────────────────────────────────
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.env}-igw"
  })
}

# ─────────────────────────────────────────
# Public Subnets
# ─────────────────────────────────────────
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name                     = "${var.env}-public-subnet-${count.index + 1}"
    "kubernetes.io/role/elb" = "1"
  })
}

# ─────────────────────────────────────────
# Private Subnets
# ─────────────────────────────────────────
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.common_tags, {
    Name                              = "${var.env}-private-subnet-${count.index + 1}"
    "kubernetes.io/role/internal-elb" = "1"
  })
}

# ─────────────────────────────────────────
# NAT Gateway (Single for dev, Multi for prod)
# ─────────────────────────────────────────
resource "aws_eip" "nat" {
  count  = var.env == "prod" ? length(var.public_subnets) : 1
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "${var.env}-nat-eip-${count.index + 1}"
  })
}

resource "aws_nat_gateway" "main" {
  count         = var.env == "prod" ? length(var.public_subnets) : 1
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.common_tags, {
    Name = "${var.env}-nat-gw-${count.index + 1}"
  })

  depends_on = [aws_internet_gateway.main]
}

# ─────────────────────────────────────────
# Route Tables
# ─────────────────────────────────────────
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.env}-public-rt"
  })
}

resource "aws_route_table" "private" {
  count  = var.env == "prod" ? length(var.private_subnets) : 1
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[var.env == "prod" ? count.index : 0].id
  }

  tags = merge(var.common_tags, {
    Name = "${var.env}-private-rt-${count.index + 1}"
  })
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[var.env == "prod" ? count.index : 0].id
}
