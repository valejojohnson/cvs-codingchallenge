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
module "important_logline_alarm" {
  source = "./modules/logline_alarm"

  # Target log group
  log_group_name    = "/aws/lambda/error-service"
  create_log_group  = true        # set true if you want this module to create it
  retention_in_days = 3

  filter_pattern = "\"CRITICAL: Payment failed\""

  # Email destination (must confirm the subscription email once)
  alert_email     = "ochin@googly.net"

  # (Optional) naming tweaks
  metric_name      = "CriticalPaymentFailures"
  metric_namespace = "ErrorService"
  sns_topic_name   = "critical-payment-failures"
  alarm_name       = "critical-payment-failures-gt10-in-60s"
}
}