data "azurerm_virtual_machine_scale_set" "vmss" {
  for_each = var.vmss_autoscale_settings
  name                = each.value.vmss_name
  resource_group_name = each.value.resource_group_name
}


