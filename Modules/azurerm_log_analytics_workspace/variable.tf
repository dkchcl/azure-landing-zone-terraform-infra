variable "log_analytics_workspaces" {
  description = "Log Analytics Workspaces"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string

    allow_resource_only_permissions = optional(bool)
    local_authentication_enabled    = optional(bool)
    sku                             = optional(string)
    retention_in_days               = optional(number)
    daily_quota_gb                  = optional(number)
    cmk_for_query_forced            = optional(bool)
    internet_ingestion_enabled      = optional(bool)
    internet_query_enabled          = optional(bool)

    reservation_capacity_in_gb_per_day      = optional(number)
    data_collection_rule_id                 = optional(string)
    immediate_data_purge_on_30_days_enabled = optional(bool)

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))

    tags = optional(map(string))
  }))
}




