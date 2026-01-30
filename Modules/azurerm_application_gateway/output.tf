# output "backend_pool_ids" {
#   value = {
#     for k, v in azurerm_application_gateway.appgw :
#     k => v.backend_address_pool[*].id
#   }
# }

output "backend_pool_ids" {
  value = {
    for k, v in azurerm_application_gateway.appgw :
    k => {
      for p in v.backend_address_pool :
      p.name => p.id
    }
  }
}



