#############################################
# Identity, VPC, and subnet discovery
#############################################

data "aws_caller_identity" "current" {}

# Default VPC
data "aws_vpc" "default" {
  default = true
}

# All subnets in that VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Details for each subnet
data "aws_subnet" "all" {
  for_each = toset(data.aws_subnets.default.ids)
  id       = each.value
}

#############################################
# Classify subnets using map_public_ip_on_launch
#############################################

locals {
  public_subnet_ids_raw = [
    for s in data.aws_subnet.all : s.id
    if try(s.map_public_ip_on_launch, false)
  ]

  private_subnet_ids_raw = [
    for s in data.aws_subnet.all : s.id
    if !try(s.map_public_ip_on_launch, false)
  ]

  # Fallback: if no private subnets exist in default VPC, reuse public
  public_subnet_ids  = local.public_subnet_ids_raw
  private_subnet_ids = length(local.private_subnet_ids_raw) > 0 ? local.private_subnet_ids_raw : local.public_subnet_ids_raw
}

#############################################
# Assume-role policy documents (used by ecs/iam/codepipeline)
#############################################

# ECS task execution & task role trust policy
data "aws_iam_policy_document" "task_exec_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# CodeBuild service role trust policy
data "aws_iam_policy_document" "cb_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

# CodePipeline service role trust policy
data "aws_iam_policy_document" "pipeline_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

data "aws_region" "current" {}
data "aws_route_tables" "all_in_vpc" {
  vpc_id = data.aws_vpc.default.id
}