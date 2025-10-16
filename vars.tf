############################
# Global / app defaults
############################
variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Application/service name"
  type        = string
  default     = "guessing-game"
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "ALB/ECS health check path"
  type        = string
  default     = "/health"
}

variable "desired_count" {
  description = "Number of Fargate tasks"
  type        = number
  default     = 2
}

variable "task_cpu" {
  description = "Task CPU units (e.g., 256 = 0.25 vCPU)"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Task memory (MiB)"
  type        = number
  default     = 512
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    Project = "cvs-codingchallenge"
    Owner   = "Valejo"
  }
}

############################
# CodePipeline
############################
variable "codestar_connection_arn" {
  description = "Existing CodeStar (CodeConnections) ARN to GitHub"
  type        = string
  default     = "arn:aws:codeconnections:us-east-1:223553688319:connection/86c61d10-a3d7-4871-9a7e-d8fb3f99faa8"
}

variable "github_owner" {
  type    = string
  default = "valejojohnson"
}

variable "github_repo" {
  type    = string
  default = "cvs-codingchallenge"
}

variable "github_branch" {
  type    = string
  default = "main"
}