############################
# Global / app defaults
############################
variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-west-1"
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
  sensitive   = true
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

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "bucket_name" {
  description = "Globally-unique S3 bucket name"
  type        = string
  default     = "valejo-cvs-bucket"
}

variable "force_destroy" {
  description = "Allow deletion of non-empty buckets"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable object versioning"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "Optional KMS key ID/ARN for SSE-KMS. Leave empty for SSE-S3 (AES256)."
  type        = string
  default     = ""
}

variable "kms_bucket_key_enabled" {
  description = "Enable S3 Bucket Keys when using KMS"
  type        = bool
  default     = true
}

variable "create_log_group" {
  description = "Create the CloudWatch log group if it doesn't exist"
  type        = bool
  default     = true
}

variable "log_group_name" {
  description = "CloudWatch Logs log group to scan (e.g., /aws/lambda/my-fn)"
  type        = string
  default     = "/aws/lambda/cvs-function"
}

variable "retention_in_days" {
  description = "Retention for created log group (ignored if create_log_group = false)"
  type        = number
  default     = 3
}

variable "filter_pattern" {
  description = "Filter pattern to match (e.g., ERROR)"
  type        = string
  default     = "ERROR"
}

variable "alarm_name" {
  description = "Name of the CloudWatch alarm"
  type        = string
  default     = "log-line-spike"
}

variable "metric_namespace" {
  description = "Namespace for custom metric"
  type        = string
  default     = "App/LogPatterns"
}

variable "metric_name" {
  description = "Metric name created by the filter"
  type        = string
  default     = "MatchedLines"
}

variable "threshold" {
  description = "Matches per period to trigger the alarm"
  type        = number
  default     = 10
}

variable "period" {
  description = "Period in seconds"
  type        = number
  default     = 60
}

variable "evaluation_periods" {
  description = "Number of periods for evaluation"
  type        = number
  default     = 1
}

variable "treat_missing_data" {
  description = "How to treat missing data"
  type        = string
  default     = "notBreaching"
}

variable "alert_email" {
  description = "Email endpoint for SNS subscription"
  type        = string
  default     = "cubists.gables0r@icloud.com"
}

variable "sns_topic_name" {
  description = "SNS topic name"
  type        = string
  default     = "log-alerts"
}
