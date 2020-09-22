locals {
  lsm_alarm_config = "${var.lsm_alarms_enabled && var.lsm_managed ? "enabled":"disabled"}"
  customer_alarm_config  = "${var.customer_alarms_enabled || ! var.lsm_managed ? "enabled":"disabled"}"
  customer_ok_config     = "${var.customer_alarms_cleared && (var.customer_alarms_enabled || ! var.lsm_managed) ? "enabled":"disabled"}"

  lsm_alarm_actions = {
    enabled = ["${local.lsm_sns_topic[var.severity]}"]

    disabled = []
  }

  customer_alarm_actions = {
    enabled = "${compact(var.notification_topic)}"

    disabled = []
  }

  lsm_sns_topic = {
    standard  = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:lsm-support-standard"
    urgent    = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:lsm-support-urgent"
    emergency = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:lsm-support-emergency"
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_cloudwatch_metric_alarm" "alarm" {
  count = "${var.alarm_count}"

  alarm_description   = "${var.alarm_description}"
  alarm_name          = "${var.alarm_count > 1 ? format("%v-%03d", var.alarm_name, count.index + 1) : var.alarm_name}"
  comparison_operator = "${var.comparison_operator}"
  dimensions          = "${var.dimensions[count.index]}"
  evaluation_periods  = "${var.evaluation_periods}"
  metric_name         = "${var.metric_name}"
  namespace           = "${var.namespace}"
  period              = "${var.period}"
  statistic           = "${var.statistic}"
  threshold           = "${var.threshold}"
  unit                = "${var.unit}"

  alarm_actions = ["${concat(local.lsm_alarm_actions[local.lsm_alarm_config],
                             local.customer_alarm_actions[local.customer_alarm_config])}"]

  ok_actions = ["${concat(local.lsm_alarm_actions[local.lsm_alarm_config],
                            local.customer_alarm_actions[local.customer_ok_config])}"]
}