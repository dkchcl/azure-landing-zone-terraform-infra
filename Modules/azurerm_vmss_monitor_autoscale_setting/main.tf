resource "azurerm_monitor_autoscale_setting" "vmss_autoscale" {
  for_each = var.vmss_autoscale_settings

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  target_resource_id  = data.azurerm_virtual_machine_scale_set.vmss[each.key].id
  enabled             = lookup(each.value, "enabled", true)

  dynamic "profile" {
    for_each = each.value.profile
    content {
      name = profile.value.name

      capacity {
        default = profile.value.capacity.default
        minimum = profile.value.capacity.minimum
        maximum = profile.value.capacity.maximum
      }

      dynamic "rule" {
        for_each = lookup(profile.value, "rule", null) == null ? [] : profile.value.rule
        content {

          metric_trigger {
            metric_name              = rule.value.metric_trigger.metric_name
            metric_resource_id       = data.azurerm_virtual_machine_scale_set.vmss[each.key].id
            operator                 = rule.value.metric_trigger.operator
            statistic                = rule.value.metric_trigger.statistic
            time_aggregation         = rule.value.metric_trigger.time_aggregation
            time_grain               = rule.value.metric_trigger.time_grain
            time_window              = rule.value.metric_trigger.time_window
            threshold                = rule.value.metric_trigger.threshold
            metric_namespace         = lookup(rule.value.metric_trigger, "metric_namespace", null)
            divide_by_instance_count = lookup(rule.value.metric_trigger, "divide_by_instance_count", null)

            dynamic "dimensions" {
              for_each = lookup(rule.value.metric_trigger, "dimensions", null) == null ? [] : rule.value.metric_trigger.dimensions
              content {
                name     = dimensions.value.name
                operator = dimensions.value.operator
                values   = dimensions.value.values
              }
            }
          }

          scale_action {
            direction = rule.value.scale_action.direction
            type      = rule.value.scale_action.type
            value     = rule.value.scale_action.value
            cooldown  = rule.value.scale_action.cooldown
          }
        }
      }

      dynamic "fixed_date" {
        for_each = lookup(profile.value, "fixed_date", null) == null ? [] : [profile.value.fixed_date]
        content {
          start    = fixed_date.value.start
          end      = fixed_date.value.end
          timezone = lookup(fixed_date.value, "timezone", null)
        }
      }

      dynamic "recurrence" {
        for_each = lookup(profile.value, "recurrence", null) == null ? [] : [profile.value.recurrence]
        content {
          timezone = lookup(recurrence.value, "timezone", null)
          days     = recurrence.value.days
          hours    = recurrence.value.hours
          minutes  = recurrence.value.minutes
        }
      }
    }
  }

  dynamic "notification" {
    for_each = lookup(each.value, "notification", null) == null ? [] : [each.value.notification]
    content {

      dynamic "email" {
        for_each = lookup(notification.value, "email", null) == null ? [] : [notification.value.email]
        content {
          send_to_subscription_administrator    = lookup(email.value, "send_to_subscription_administrator", null)
          send_to_subscription_co_administrator = lookup(email.value, "send_to_subscription_co_administrator", null)
          custom_emails                         = lookup(email.value, "custom_emails", null)
        }
      }

      dynamic "webhook" {
        for_each = lookup(notification.value, "webhook", null) == null ? [] : notification.value.webhook
        content {
          service_uri = webhook.value.service_uri
          properties  = lookup(webhook.value, "properties", null)
        }
      }
    }
  }

  dynamic "predictive" {
    for_each = lookup(each.value, "predictive", null) == null ? [] : [each.value.predictive]
    content {
      scale_mode      = predictive.value.scale_mode
      look_ahead_time = lookup(predictive.value, "look_ahead_time", null)
    }
  }

  tags = lookup(each.value, "tags", null)
}

















