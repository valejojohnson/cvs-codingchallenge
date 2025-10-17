output "sns_topic_arn" {
  value       = aws_sns_topic.this.arn
  description = "ARN of the SNS topic used by the alarm."
}

output "alarm_arn" {
  value       = aws_cloudwatch_metric_alarm.this.arn
  description = "ARN of the created CloudWatch alarm."
}

output "metric_filter_name" {
  value       = aws_cloudwatch_log_metric_filter.this.name
  description = "Name of the created CloudWatch log metric filter."
}

output "log_group_arn" {
  value       = try(aws_cloudwatch_log_group.this[0].arn, null)
  description = "ARN of the created log group (if create_log_group=true)."
}