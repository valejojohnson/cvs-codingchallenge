#############################################
# VPC Endpoints so Fargate in PRIVATE subnets
# can reach ECR, Logs, and S3 without Internet/NAT
#############################################

# All route tables in the default VPC (for S3 gateway endpoint)
data "aws_route_tables" "all_in_vpc" {
  vpc_id = data.aws_vpc.default.id
}

# Security group for Interface VPC Endpoints
# Allow HTTPS from anywhere inside the VPC (simple + safe)
resource "aws_security_group" "vpce" {
  name        = "guessing-game-vpce-sg"
  description = "SG for VPC Interface Endpoints (ECR/Logs)"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Interface VPC Endpoints
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id               = data.aws_vpc.default.id
  service_name         = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type    = "Interface"
  subnet_ids           = local.private_subnet_ids
  security_group_ids   = [aws_security_group.vpce.id]
  private_dns_enabled  = true
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id               = data.aws_vpc.default.id
  service_name         = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type    = "Interface"
  subnet_ids           = local.private_subnet_ids
  security_group_ids   = [aws_security_group.vpce.id]
  private_dns_enabled  = true
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id               = data.aws_vpc.default.id
  service_name         = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type    = "Interface"
  subnet_ids           = local.private_subnet_ids
  security_group_ids   = [aws_security_group.vpce.id]
  private_dns_enabled  = true
}

# Gateway VPC Endpoint for S3 (attach to all route tables in VPC)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = data.aws_vpc.default.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = data.aws_route_tables.all_in_vpc.ids
}