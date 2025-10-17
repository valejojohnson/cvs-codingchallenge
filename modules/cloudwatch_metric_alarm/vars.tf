variable "log_group_name" {
  type        = string
  description = "Target CloudWatch Log Group name where the filter will be applied."
}

variable "create_log_group" {
  type        = bool
  description = "Whether to create the log group in this module."
  default     = false
}

variable "retention_in_days" {
  type        = number
  description = "Retention for the (optionally created) log group."
  default     = 30
}

variable "filter_pattern" {
  type        = string
  description = "CloudWatch Logs filter pattern (e.g., for specific error strings)."
}

variable "metric_name" {
  type        = string
  description = "Name of the metric created by the log metric filter."
}

variable "metric_namespace" {
  type        = string
  description = "Namespace of the metric created by the log metric filter."
}

variable "sns_topic_name" {
  type        = string
  description = "Name for the SNS topic to notify on alarm."
}

variable "alarm_name" {
  type        = string
  description = "Alarm name; if empty, a sensible default is used."
  default     = ""
}

variable "alarm_description" {
  type        = string
  description = "Description for the alarm."
  default     = "Alarm generated from log metric filter."
}

variable "comparison_operator" {
  type        = string
  description = "Comparison operator (e.g., GreaterThanOrEqualToThreshold)."
}

variable "threshold" {
  type        = number
  description = "Alarm threshold."
}

variable "evaluation_periods" {
  type        = number
  description = "Number of periods to evaluate for the alarm."
}

variable "period" {
  type        = number
  description = "Period, in seconds, over which the statistic is applied."
}

variable "statistic" {
  type        = string
  description = "Statistic to apply (e.g., Sum, Average)."
  default     = "Sum"
}

variable "treat_missing_data" {
  type        = string
  description = "How to treat missing data (e.g., notBreaching, breaching, ignore, missing)."
  default     = "notBreaching"
}

variable "datapoints_to_alarm" {
  type        = number
  description = "The number of datapoints that must be breaching to trigger the alarm."
  default     = null
}

variable "alarm_actions_enabled" {
  type        = bool
  description = "Enable/disable alarm actions (useful for dry-runs)."
  default     = true
}