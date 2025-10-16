
############################
# Resources
############################
resource "aws_cloudwatch_log_metric_filter" "this" {
  name           = "${var.metric_namespace}-${var.metric_name}-filter"
  log_group_name = var.log_group_name
  pattern        = var.filter_pattern

  metric_transformation {
    name      = var.metric_name
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_sns_topic" "this" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name          = var.alarm_name
  alarm_description   = "Alert when '${var.filter_pattern}' appears >= ${var.threshold} times in ${var.period}s."
  namespace           = var.metric_namespace
  metric_name         = var.metric_name
  statistic           = "Sum"
  period              = var.period
  evaluation_periods  = var.evaluation_periods
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = var.threshold
  treat_missing_data  = var.treat_missing_data
  alarm_actions       = [aws_sns_topic.this.arn]

  depends_on = [aws_cloudwatch_log_metric_filter.this]
}

resource "aws_cloudwatch_log_group" "this" {
  count             = var.create_log_group ? 1 : 0
  name              = var.log_group_name
  retention_in_days = var.retention_in_days

  # Prevent accidental deletion of historical logs on destroy
  lifecycle {
    prevent_destroy = true
  }
}