variable "vmss_autoscale_settings" {
  description = "Autoscale settings for Azure resources (VMSS, App Service, etc.)"
  type = map(object({

    # ---------------- REQUIRED ----------------
    name                = string
    resource_group_name = string
    location            = string
    target_resource_id  = string
    vmss_name           = optional(string)

    profile = list(object({
      name = string

      capacity = object({
        default = number
        minimum = number
        maximum = number
      })

      rule = optional(list(object({
        metric_trigger = object({
          metric_name              = string
          metric_resource_id       = string
          operator                 = string
          statistic                = string
          time_aggregation         = string
          time_grain               = string
          time_window              = string
          threshold                = number
          metric_namespace         = optional(string)
          divide_by_instance_count = optional(bool)

          dimensions = optional(list(object({
            name     = string
            operator = string
            values   = list(string)
          })))
        })

        scale_action = object({
          direction = string
          type      = string
          value     = string
          cooldown  = string
        })
      })))

      fixed_date = optional(object({
        start    = string
        end      = string
        timezone = optional(string)
      }))

      recurrence = optional(object({
        timezone = optional(string)
        days     = list(string)
        hours    = list(number)
        minutes  = list(number)
      }))
    }))

    # ---------------- OPTIONAL ----------------
    enabled = optional(bool)

    notification = optional(object({
      email = optional(object({
        send_to_subscription_administrator    = optional(bool)
        send_to_subscription_co_administrator = optional(bool)
        custom_emails                         = optional(list(string))
      }))

      webhook = optional(list(object({
        service_uri = string
        properties  = optional(map(string))
      })))
    }))

    predictive = optional(object({
      scale_mode      = string
      look_ahead_time = optional(string)
    }))

    tags = optional(map(string))

  }))
}






