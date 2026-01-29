resource "azurerm_log_analytics_workspace" "log_analytics_workspaces" {
  for_each = var.log_analytics_workspaces

  name                                    = each.value.name
  resource_group_name                     = each.value.resource_group_name
  location                                = each.value.location
  allow_resource_only_permissions         = lookup(each.value, "allow_resource_only_permissions", null)
  local_authentication_enabled            = lookup(each.value, "local_authentication_enabled", null)
  sku                                     = lookup(each.value, "sku", null)
  retention_in_days                       = lookup(each.value, "retention_in_days", null)
  daily_quota_gb                          = lookup(each.value, "daily_quota_gb", null)
  cmk_for_query_forced                    = lookup(each.value, "cmk_for_query_forced", null)
  internet_ingestion_enabled              = lookup(each.value, "internet_ingestion_enabled", null)
  internet_query_enabled                  = lookup(each.value, "internet_query_enabled", null)
  reservation_capacity_in_gb_per_day      = lookup(each.value, "reservation_capacity_in_gb_per_day", null)
  data_collection_rule_id                 = lookup(each.value, "data_collection_rule_id", null)
  immediate_data_purge_on_30_days_enabled = lookup(each.value, "immediate_data_purge_on_30_days_enabled", null)

  dynamic "identity" {
    for_each = lookup(each.value, "identity", null) == null ? [] : [each.value.identity]
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  tags = lookup(each.value, "tags", null)
}






