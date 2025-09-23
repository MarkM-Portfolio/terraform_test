locals {
  #Form a list of maps containing attributes for billing_alarm_per_acct_and_service resource
  acct_services_alarm_list = distinct(flatten([
    for acct in var.billing_alarm_configs_in : [
      for service in acct.services : {
        alarm_name        = "${acct.name}-${service.ServiceName} Billing Alarm"
        alarm_description = "${service.ServiceName} from ${acct.name} has exceeded set threshold"
        period            = service.period
        threshold         = service.threshold
        alarm_actions     = acct.alarm_actions
        LinkedAccount     = acct.acct_number
        ServiceName       = service.ServiceName
        Currency          = service.Currency
      }
    ]
  ]))

  #Form a list of maps containing attributes for billing_alarm_per_acct resource
  acct_alarm_list = distinct(flatten([
    for acct in var.billing_alarm_configs_in : [{
      alarm_name        = "${acct.name} Total Billing Alarm"
      alarm_description = "The total billing amount for ${acct.name} has exceeded set threshold"
      period            = acct.period
      threshold         = acct.threshold
      alarm_actions     = acct.alarm_actions
      LinkedAccount     = acct.acct_number
      Currency          = acct.Currency
    }]
  ]))

}