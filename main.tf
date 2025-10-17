provider "aws" {
  region = "us-west-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1"
    }
  }
}


# Calling the Cloudwatch module
module "cw_log_failures" {
  source = "./modules/cloudwatch_metric_alarm"

  # Log group settings
  log_group_name    = "/aws/lambda/logging-in"
  create_log_group  = true
  retention_in_days = 30

  # Filter -> metric
  filter_pattern   = "{ ($.status = \"Failed\") }"
  metric_name      = "LoginFailures"
  metric_namespace = "MyService"

  # Alarm
  sns_topic_name       = "myservice-alerts"
  alarm_name           = "LoginFailuresAlarm"
  alarm_description    = "Triggers when login failures are detected."
  comparison_operator  = "GreaterThanOrEqualToThreshold"
  threshold            = 1
  evaluation_periods   = 1
  period               = 60
  statistic            = "Sum"
  treat_missing_data   = "notBreaching"
  datapoints_to_alarm  = 1
  alarm_actions_enabled = true
}