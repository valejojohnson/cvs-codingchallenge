variable "log_group_name" {
  type        = string
  description = "CloudWatch Log Group to scan."
}

variable "create_log_group" {
  type        = bool
  default     = false
  description = "Create the log group here (if it doesn't already exist)."
}

variable "retention_in_days" {
  type        = number
  default     = 30
}

variable "filter_pattern" {
  type        = string
  description = "CloudWatch Logs filter pattern that matches the target log line."
}

variable "metric_name" {
  type        = string
  default     = "MatchedLogCount"
}

variable "metric_namespace" {
  type        = string
  default     = "LogLine/Alerts"
}

variable "sns_topic_name" {
  type        = string
  default     = "logline-alerts"
}

variable "alert_email" {
  type        = string
  description = "Email address to notify (will receive a confirmation email)."
}

variable "alarm_name" {
  type        = string
  default     = null
}

variable "alarm_description" {
  type        = string
  default     = "Email when the specified log line occurs >10 times in 1 minute."
}