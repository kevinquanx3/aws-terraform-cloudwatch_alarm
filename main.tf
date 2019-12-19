/**
 * # aws-terraform-cloudwatch_alarm
 *This module deploys a customized CloudWatch Alarm, for use in generating customer notifications or Rackspace support tickets.
 *
 *## Basic Usage
 *
 *```
 *module "alarm" {
 *  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-cloudwatch_alarm//?ref=v0.0.1"
 *
 *  alarm_description        = "High CPU usage."
 *  alarm_name               = "MyCloudWatchAlarm"
 *  comparison_operator      = "GreaterThanThreshold"
 *  customer_alarms_enabled  = true
 *  evaluation_periods       = 5
 *  metric_name              = "CPUUtilization"
 *  notification_topic       = ["${var.notification_topic}"]
 *  namespace                = "AWS/EC2"
 *  period                   = 60
 *  rackspace_alarms_enabled = true
 *  rackspace_managed        = true
 *  severity                 = "urgent"
 *  statistic                = "Average"
 *  threshold                = 90
 *
 *  dimension {
 *    InstanceId = "i-123456"
 *  }
 *}
 *```
 *
 * Full working references are available at [examples](examples)
 *
 */

terraform {
  required_version = ">= 0.12"
}

locals {
  rackspace_alarm_config = var.rackspace_alarms_enabled && var.rackspace_managed ? "enabled" : "disabled"
  customer_alarm_config  = var.customer_alarms_enabled || false == var.rackspace_managed ? "enabled" : "disabled"
  customer_ok_config     = var.customer_alarms_cleared && var.customer_alarms_enabled || false == var.rackspace_managed ? "enabled" : "disabled"

  rackspace_alarm_actions = {
    enabled  = [local.rackspace_sns_topic[var.severity]]
    disabled = []
  }

  customer_alarm_actions = {
    enabled  = compact(var.notification_topic)
    disabled = []
  }

  rackspace_sns_topic = {
    standard  = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:rackspace-support-standard"
    urgent    = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:rackspace-support-urgent"
    emergency = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:rackspace-support-emergency"
  }
}

data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

resource "aws_cloudwatch_metric_alarm" "alarm" {
  count = var.alarm_count

  alarm_description   = var.alarm_description
  alarm_name          = var.alarm_count > 1 ? format("%v-%03d", var.alarm_name, count.index + 1) : var.alarm_name
  comparison_operator = var.comparison_operator
  dimensions          = var.dimensions[count.index]
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  unit                = var.unit

  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  alarm_actions = [
    concat(
      local.rackspace_alarm_actions[local.rackspace_alarm_config],
      local.customer_alarm_actions[local.customer_alarm_config],
    ),
  ]

  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  ok_actions = [
    concat(
      local.rackspace_alarm_actions[local.rackspace_alarm_config],
      local.customer_alarm_actions[local.customer_ok_config],
    ),
  ]
}
