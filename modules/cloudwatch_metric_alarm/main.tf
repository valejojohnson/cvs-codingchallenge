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

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name          = var.alarm_name != "" ? var.alarm_name : "${var.metric_namespace}-${var.metric_name}-alarm"
  alarm_description   = var.alarm_description
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.metric_namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  treat_missing_data  = var.treat_missing_data
  datapoints_to_alarm = var.datapoints_to_alarm
  actions_enabled     = var.alarm_actions_enabled

  # send to module-created SNS topic (unless actions disabled)
  alarm_actions = var.alarm_actions_enabled ? [aws_sns_topic.this.arn] : []

  depends_on = [aws_cloudwatch_log_metric_filter.this]
}

resource "aws_cloudwatch_log_group" "this" {
  count             = var.create_log_group ? 1 : 0
  name              = var.log_group_name
  retention_in_days = var.retention_in_days

  lifecycle {
    prevent_destroy = false
  }
}