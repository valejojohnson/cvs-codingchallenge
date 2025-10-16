output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "alarm_arn" {
  value = aws_cloudwatch_metric_alarm.this.arn
}

output "topic_arn" {
  value = aws_sns_topic.this.arn
}