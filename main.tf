provider "aws" {
  region = "us-west-1"
}

resource "random_pet" "this" {
  length = 2
  prefix = "eks"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1"
    }
  }
}