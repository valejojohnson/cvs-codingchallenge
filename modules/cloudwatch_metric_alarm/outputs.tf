output "alarm_arn"       { value = aws_cloudwatch_metric_alarm.this.arn }
output "sns_topic_arn"   { value = aws_sns_topic.this.arn }
output "metric_filter"   { value = aws_cloudwatch_log_metric_filter.this.name }
output "log_group_arn"   { value = try(aws_cloudwatch_log_group.lg[0].arn, null) }