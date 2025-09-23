resource "aws_cloudwatch_metric_alarm" "alb_unhealthyhosts" {
  for_each                  = var.cloudwatch_alarm_configs_in
  alarm_name                = each.value.alarm_name
  comparison_operator       = each.value.comparison
  evaluation_periods        = each.value.evaluation_periods
  period                    = each.value.period
  threshold                 = each.value.threshold
  alarm_description         = "Number of unhealthy hosts in the ${each.key} Target Group"
  alarm_actions             = each.value.alarm_actions
  ok_actions                = each.value.ok_actions
  insufficient_data_actions = each.value.insufficient_data_actions
  metric_name               = "UnHealthyHostCount"
  namespace                 = "AWS/ApplicationELB"
  statistic                 = "Average"
  actions_enabled           = "true"
  dimensions = {
    TargetGroup  = each.value.target_group
    LoadBalancer = each.value.loadbalancer
  }
}

resource "aws_cloudwatch_metric_alarm" "billing_alarm_per_acct_and_service" {
  provider          = aws.us_east_1
  for_each          = { for entry in local.acct_services_alarm_list : "${entry.alarm_name}" => entry }
  alarm_name        = each.value.alarm_name
  alarm_description = each.value.alarm_description
  period              = each.value.period
  threshold           = each.value.threshold
  alarm_actions       = each.value.alarm_actions
  evaluation_periods  = "1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  statistic           = "Maximum"
  actions_enabled     = "true"
  dimensions = {
    LinkedAccount = each.value.LinkedAccount
    ServiceName   = each.value.ServiceName
    Currency      = each.value.Currency
  }
}

resource "aws_cloudwatch_metric_alarm" "billing_alarm_per_acct" {
  provider          = aws.us_east_1
  for_each          = { for entry in local.acct_alarm_list : "${entry.alarm_name}" => entry }
  alarm_name        = each.value.alarm_name
  alarm_description = each.value.alarm_description
  period              = each.value.period
  threshold           = each.value.threshold
  alarm_actions       = each.value.alarm_actions
  evaluation_periods  = "1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  statistic           = "Maximum"
  actions_enabled     = "true"
  dimensions = {
    LinkedAccount = each.value.LinkedAccount
    Currency      = each.value.Currency
  }
}

