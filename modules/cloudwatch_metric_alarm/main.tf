resource "aws_cloudwatch_log_metric_filter" "this" {
  name           = "${var.metric_namespace}-${var.metric_name}-filter"
  log_group_name = var.log_group_name
  pattern        = var.filter_pattern

  metric_transformation {
    name      = var.metric_name
    namespace = var.metric_namespace
    value     = "1"            # count 1 per match
  }
}

resource "aws_cloudwatch_log_group" "lg" {
  count             = var.create_log_group ? 1 : 0
  name              = var.log_group_name
  retention_in_days = var.retention_in_days
}

resource "aws_sns_topic" "this" {
  name = var.sns_topic_name
}

# Email subscription (recipient must confirm)
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name          = coalesce(var.alarm_name, "${var.metric_namespace}-${var.metric_name}-gt10-in-60s")
  alarm_description   = var.alarm_description
  metric_name         = var.metric_name
  namespace           = var.metric_namespace
  statistic           = "Sum"
  period              = 60                       # 1 minute windows
  evaluation_periods  = 1
  threshold           = 10
  comparison_operator = "GreaterThanThreshold"   # strictly > 10
  treat_missing_data  = "notBreaching"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.this.arn]

  depends_on = [aws_cloudwatch_log_metric_filter.this]
}