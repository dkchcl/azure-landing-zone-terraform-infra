data "azurerm_subnet" "subnet" {
  for_each             = var.virtual_machine_scale_sets
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_network_security_group" "nsg" {
  for_each            = var.virtual_machine_scale_sets
  name                = each.value.nsg_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_key_vault" "kv" {
  for_each            = var.virtual_machine_scale_sets
  name                = each.value.key_vault_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_key_vault_secret" "kvs" {
  for_each     = var.virtual_machine_scale_sets
  name         = each.value.secret_name
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}

data "azurerm_key_vault_secret" "kvs1" {
  for_each     = var.virtual_machine_scale_sets
  name         = each.value.secret_password
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}

# data "azurerm_application_gateway" "appgw" {
#   for_each            = var.virtual_machine_scale_sets
#   name                = each.value.app_gateway_name
#   resource_group_name = each.value.resource_group_name
# }

# data "azurerm_lb" "lb" {
#   for_each            = var.virtual_machine_scale_sets
#   name                = each.value.load_balancer_name
#   resource_group_name = each.value.resource_group_name
# }

# data "azurerm_lb_backend_address_pool" "ib_backend" {
#   for_each        = var.virtual_machine_scale_sets
#   name            = each.value.backend_pool_name
#   loadbalancer_id = data.azurerm_lb.lb[each.key].id
# }




