module "rg" {
  source  = "../../Modules/azurerm_resource_group"
  rg_name = var.rg_name
}

module "vnet" {
  depends_on = [module.rg]
  source     = "../../Modules/azurerm_virtual_network"
  vnet_name  = var.vnet_name
}

module "subnet" {
  depends_on = [module.vnet]
  source     = "../../Modules/azurerm_subnet"
  subnets    = var.subnets
}

module "public_ip" {
  depends_on = [module.rg]
  source     = "../../Modules/azurerm_public_ip"
  public_ip  = var.public_ip
}

module "nsg" {
  depends_on = [module.rg]
  source     = "../../Modules/azurerm_network_security_group"
  nsgs       = var.nsgs
}

module "subnet_nsg_nic_assoc" {
  depends_on           = [module.nsg, module.subnet, module.nic]
  source               = "../../Modules/azurerm_subnet_nsg_nic_assoc"
  subnet_nsg_nic_assoc = var.subnet_nsg_nic_assoc
}

# module "bastion_host" {
#   depends_on    = [module.public_ip, module.subnet, ]
#   source        = "../../Modules/azurerm_bastion_host"
#   bastion_hosts = var.bastion_hosts
# }

module "kv" {
  depends_on = [module.rg]
  source     = "../../Modules/azurerm_key_vault"
  key_vaults = var.key_vaults
}

module "kvs" {
  depends_on        = [module.kv]
  source            = "../../Modules/azurerm_key_vault_secret"
  key_vault_secrets = var.key_vault_secrets
}

module "nic" {
  depends_on = [module.subnet, module.public_ip]
  source     = "../../Modules/azurerm_network_Interface"
  nics       = var.nics
}

# module "stg" {
#   depends_on       = [module.rg]
#   source           = "../../Modules/azurerm_storage_account"
#   storage_accounts = var.storage_accounts
# }

# module "sql_server" {
#   depends_on  = [module.rg, module.kvs]
#   source      = "../../Modules/azurerm_sql_server"
#   sql_servers = var.sql_servers
# }

# module "sql_db" {
#   depends_on    = [module.sql_server]
#   source        = "../../Modules/azurerm_sql_database"
#   sql_databases = var.sql_databases
# }

module "lb" {
  depends_on     = [module.rg, module.subnet, module.nsg]
  source         = "../../Modules/azurerm_internal_load_balancer"
  load_balancers = var.load_balancers
}

module "vmss" {
  depends_on = [module.nic, module.lb, module.kvs, module.appgw]
  source     = "../../Modules/azurerm_linux_virtual_machine_scale_set"
  # virtual_machine_scale_sets = var.virtual_machine_scale_sets

  virtual_machine_scale_sets = {
    for k, v in var.virtual_machine_scale_sets :
    k => merge(v,
      k == "frontend" ? {
        appgw_backend_pool_ids = module.appgw.backend_pool_ids["appgw_frontend"]
      } :
      k == "backend" ? {
        lb_backend_pool_ids = [module.lb.backend_pool_ids["internal_lb"]]
      } :
      {}
    )
  }
}

module "vmss_autoscale_settings" {
  depends_on              = [module.vmss]
  source                  = "../../Modules/azurerm_vmss_monitor_autoscale_setting"
  vmss_autoscale_settings = var.vmss_autoscale_settings
}

module "appgw" {
  depends_on           = [module.rg, module.subnet, module.public_ip, module.nsg]
  source               = "../../Modules/azurerm_application_gateway"
  application_gateways = var.application_gateways
}
# module "log_analytics_workspaces" {
#   depends_on               = [module.rg]
#   source = "../../Modules/azurerm_log_analytics_workspace"
#   log_analytics_workspaces = var.log_analytics_workspaces
# }














