output "backend_pool_ids" {
  value = {
    for k, v in azurerm_application_gateway.appgw :
    k => v.backend_address_pool[*].id
  }
}


