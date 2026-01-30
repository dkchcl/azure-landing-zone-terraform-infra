output "backend_pool_ids" {
  value = {
    for k, v in azurerm_lb_backend_address_pool.lb_ba_pool :
    k => v.id
  }
}


output "ilb_private_ip" {
  value = azurerm_lb.lb["internal_lb"].frontend_ip_configuration[0].private_ip_address
}

