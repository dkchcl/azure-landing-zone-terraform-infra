# Resource Groups

rg_name = {
  rg1 = {
    name       = "dev_rg_01"
    location   = "West US 2"
    managed_by = "Terraform"
    tags = {
      env        = "dev"
      team       = "dev-007"
      created_by = "Dinesh"
    }
  }
}

# Virtual Networks

vnet_name = {
  vnet1 = {
    name                = "dev-vnet-01"
    location            = "West US 2"
    resource_group_name = "dev_rg_01"
    address_space       = ["10.0.0.0/16"]
    tags = {
      env = "dev"
    }
  }
}

# Subnets

subnets = {
  subnet1 = {
    subnet_name          = "subnet-01"
    resource_group_name  = "dev_rg_01"
    virtual_network_name = "dev-vnet-01"
    address_prefixes     = ["10.0.1.0/24"]
  }

  subnet2 = {
    subnet_name          = "subnet-02"
    resource_group_name  = "dev_rg_01"
    virtual_network_name = "dev-vnet-01"
    address_prefixes     = ["10.0.2.0/24"]
  }

  subnet3 = {
    subnet_name          = "AzureBastionSubnet"
    resource_group_name  = "dev_rg_01"
    virtual_network_name = "dev-vnet-01"
    address_prefixes     = ["10.0.3.0/24"]
  }
  subnet4 = {
    subnet_name          = "subnet-04"
    resource_group_name  = "dev_rg_01"
    virtual_network_name = "dev-vnet-01"
    address_prefixes     = ["10.0.4.0/24"]
  }
}

# Public IP Addresses

public_ip = {
  "bastion_pip" = {
    pip_name            = "dev-pip-01"
    resource_group_name = "dev_rg_01"
    location            = "West US 2"
    allocation_method   = "Static"
    tags = {
      env = "dev"
      app = "bastion"
    }
  }

  "appgw_pip" = {
    pip_name            = "dev-pip-02"
    resource_group_name = "dev_rg_01"
    location            = "West US 2"
    allocation_method   = "Static"
    tags = {
      env = "dev"
      app = "appgw"
    }
  }
}

# Network Security Groups

nsgs = {
  nsg1 = {
    nsg_name            = "devnsg01"
    location            = "West US 2"
    resource_group_name = "dev_rg_01"

    security_rule = [
      {
        name                       = "SSH_Rule"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        description                = "Allow ssh port"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },

      {
        name                       = "Allow-AppGW-Probe"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_address_prefix      = "AzureLoadBalancer"
        destination_port_range     = "8080"
        destination_address_prefix = "*"
      },
    ]

    tags = {
      env = "dev"
    }
  }

  nsg2 = {
    nsg_name            = "devnsg02"
    location            = "West US 2"
    resource_group_name = "dev_rg_01"

    security_rule = [
      {
        name                       = "SSH_Rule"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        description                = "Allow ssh port"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
    ]
  }
}

# Network Interface 

nics = {
  nic1 = {
    name                 = "dev-nic-01"
    location             = "West US 2"
    resource_group_name  = "dev_rg_01"
    virtual_network_name = "dev-vnet-01"
    subnet_name          = "subnet-01"
    ip_configuration = {
      ipconfig1 = {
        name                          = "ipconfig1"
        private_ip_address_allocation = "Dynamic"
      }
    }
  }

  nic2 = {
    name                 = "dev-nic-02"
    location             = "West US 2"
    resource_group_name  = "dev_rg_01"
    virtual_network_name = "dev-vnet-01"
    subnet_name          = "subnet-02"
    ip_configuration = {
      ipconfig2 = {
        name                          = "ipconfig2"
        private_ip_address_allocation = "Dynamic"
      }
    }
  }
}

# Subnets and NSGs Association

subnet_nsg_nic_assoc = {
  sub_nsg_assoc1 = {
    nsg_name             = "devnsg01"
    virtual_network_name = "dev-vnet-01"
    subnet_name          = "subnet-01"
    resource_group_name  = "dev_rg_01"
    nic_name             = "dev-nic-01"
  }

  sub_nsg_assoc2 = {
    nsg_name             = "devnsg02"
    virtual_network_name = "dev-vnet-01"
    subnet_name          = "subnet-02"
    resource_group_name  = "dev_rg_01"
    nic_name             = "dev-nic-02"
  }
}

# Bastion Host

# bastion_hosts = {
#   bastion1 = {
#     bastion_host_name         = "dev-bastion-host"
#     resource_group_name       = "dev_rg_01"
#     location                  = "West US 2"
#     sku                       = "Standard"
#     virtual_network_name      = "dev-vnet-01"
#     subnet_name               = "AzureBastionSubnet"
#     pip_name                  = "dev-pip-01"
#     copy_paste_enabled        = true
#     file_copy_enabled         = true
#     ip_connect_enabled        = true
#     kerberos_enabled          = false
#     scale_units               = 3
#     shareable_link_enabled    = true
#     tunneling_enabled         = true
#     session_recording_enabled = false

#     ip_configuration = {
#       name = "bastion-ipconfig"
#     }

#     tags = {
#       environment = "dev"
#       project     = "bastion-dev"
#     }
#   }
# }

# Key Vault and Key Vault Secrets

key_vaults = {
  kv1 = {
    key_vault_name              = "devnewkv05"
    location                    = "West US 2"
    resource_group_name         = "dev_rg_01"
    enabled_for_disk_encryption = true
    soft_delete_retention_days  = 7
    purge_protection_enabled    = true
    sku_name                    = "standard"

    access_policy = {
      key_permissions     = ["Get", "Create"]
      secret_permissions  = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
      storage_permissions = ["Get", "List", "Set"]
    }
  }
}

# Key Vault Secrets

key_vault_secrets = {
  vmss_users = {
    secret_name         = "vmss-username"
    secret_value        = "adminuser"
    key_vault_name      = "devnewkv05"
    resource_group_name = "dev_rg_01"
  }

  vmss_pass = {
    secret_name         = "vmss-password"
    secret_value        = "Bbpl@#123456"
    key_vault_name      = "devnewkv05"
    resource_group_name = "dev_rg_01"
  }

  sql_user = {
    secret_name         = "db-username"
    secret_value        = "dbuser"
    key_vault_name      = "devnewkv05"
    resource_group_name = "dev_rg_01"
  }

  sql_pass = {
    secret_name         = "db-password"
    secret_value        = "Bbpl@#123456"
    key_vault_name      = "devnewkv05"
    resource_group_name = "dev_rg_01"
  }

}

# Storage Accounts

# storage_accounts = {
#   "stg1" = {
#     name                     = "newstorageaccount011"
#     resource_group_name      = "dev_rg_01"
#     location                 = "West US 2"
#     account_tier             = "Standard"
#     account_replication_type = "LRS"
#     access_tier              = "Hot"
#   }
# }

# SQL Servers and Databases

# sql_servers = {
#   "server1" = {
#     name                          = "devnewsqlserver909"
#     resource_group_name           = "dev_rg_01"
#     location                      = "West US 2"
#     version                       = "12.0"
#     secret_name                   = "db-username"
#     secret_password               = "db-password"
#     key_vault_name                = "devnewkv05"
#     connection_policy             = "Default"
#     minimum_tls_version           = "1.2"
#     public_network_access_enabled = true
#     tags                          = { Environment = "Dev" }
#   }
# }

# SQL Databases
# sql_databases = {
#   "db1" = {
#     db_name             = "devdb-01"
#     sql_server_name     = "devnewsqlserver909"
#     resource_group_name = "dev_rg_01"
#     sku_name            = "GP_Gen5_2"
#     max_size_gb         = 5
#     short_term_retention_policy = {
#       retention_days = 7
#     }
#     threat_detection_policy = {
#       state                = "Enabled"
#       email_account_admins = "Enabled"
#       retention_days       = 30
#     }
#   }
# }

# Load Balancers

load_balancers = {

  internal_lb = {
    lb_name              = "dev-lb-01"
    resource_group_name  = "dev_rg_01"
    location             = "West US 2"
    virtual_network_name = "dev-vnet-01"
    subnet_name          = "subnet-02"
    sku                  = "Standard"
    sku_tier             = "Regional"

    tags = {
      environment = "dev"
      application = "frontend"
    }
    frontend_ip_configuration = {
      fe_ip = {
        name                          = "frontend-ip"
        private_ip_address_allocation = "Dynamic"
      }
    }

    # ---------------- BACKEND POOL ----------------
    ba_pool_name       = "frontend-backend-pool"
    synchronous_mode   = null
    virtual_network_id = ""

    # ---------------- NAT POOL ----------------
    lb_nat_pool_name     = "frontend-natpool"
    protocol             = "Tcp"
    frontend_port_start  = 50000
    frontend_port_end    = 50100
    natpool_backend_port = 22

    # ---------------- PROBE ----------------
    lb_probes_name      = "frontend-health-probe"
    port                = 80
    probe_protocol      = "Http"
    request_path        = "/"
    interval_in_seconds = 15
    number_of_probes    = 2

    # ---------------- LB RULE ----------------
    lb_rules_name                  = "frontend-http-rule"
    frontend_ip_configuration_name = "frontend-ip"
    lbrule_protocol                = "Tcp"
    frontend_port                  = 80
    backend_port                   = 80
    floating_ip_enabled            = false
    idle_timeout_in_minutes        = 4
    load_distribution              = "Default"
    disable_outbound_snat          = false
    tcp_reset_enabled              = false
  }
}


# Virtual Machine Scale Sets

virtual_machine_scale_sets = {

  backend = {
    name                 = "dev-vmss-02"
    resource_group_name  = "dev_rg_01"
    location             = "West US 2"
    sku                  = "Standard_D2ls_v5"
    secret_name          = "vmss-username"
    secret_password      = "vmss-password"
    key_vault_name       = "devnewkv05"
    virtual_network_name = "dev-vnet-01"
    subnet_name          = "subnet-02"
    nsg_name             = "devnsg01"
    # app_gateway_name                = optional(string)
    # load_balancer_name              = "dev-lb-01"
    # backend_pool_name               = "frontend-backend-pool"
    instances                       = 1
    upgrade_mode                    = "Manual"
    disable_password_authentication = false

    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }

    network_interface = [
      {
        name                          = "backend-nic"
        primary                       = true
        enable_accelerated_networking = true
        enable_ip_forwarding          = false

        ip_configuration = [
          {
            name    = "ipconfig1"
            primary = true
          }
        ]
      }
    ]

    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
      disk_size_gb         = 64
    }

    boot_diagnostics = {
      storage_account_uri = null
    }

    identity = {
      type = "SystemAssigned"
    }

    additional_capabilities = {
      ultra_ssd_enabled = false
    }

    tags = {
      environment = "dev"
      application = "backend"
      owner       = "devops"
    }
  }

  frontend = {
    name                 = "dev-vmss-01"
    resource_group_name  = "dev_rg_01"
    location             = "West US 2"
    sku                  = "Standard_D2ls_v5"
    secret_name          = "vmss-username"
    secret_password      = "vmss-password"
    virtual_network_name = "dev-vnet-01"
    key_vault_name       = "devnewkv05"
    subnet_name          = "subnet-01"
    nsg_name             = "devnsg01"
    # app_gateway_name                = "dev-appgw-frontend"
    instances                       = 1
    upgrade_mode                    = "Manual"
    disable_password_authentication = false

    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }

    network_interface = [
      {
        name                          = "frontend-nic"
        primary                       = true
        enable_accelerated_networking = true
        enable_ip_forwarding          = false

        ip_configuration = [
          {
            name    = "ipconfig1"
            primary = true
          }
        ]
      }
    ]

    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
      disk_size_gb         = 64
    }

    boot_diagnostics = {
      storage_account_uri = null
    }

    identity = {
      type = "SystemAssigned"
    }

    additional_capabilities = {
      ultra_ssd_enabled = false
    }

    tags = {
      environment = "dev"
      application = "frontend"
      owner       = "devops"
    }
  }
}

# VMSS Autoscale Settings

vmss_autoscale_settings = {

  vmss_backend_autoscale = {
    name                = "dev-vmss-02-autoscale"
    resource_group_name = "dev_rg_01"
    location            = "West US 2"
    vmss_name           = "dev-vmss-02"

    # VMSS Resource ID
    target_resource_id = ""

    enabled = true
    profile = [
      {
        name = "default"
        capacity = {
          default = 1
          minimum = 1
          maximum = 5
        }

        rule = [
          # ---------- SCALE OUT ----------
          {
            metric_trigger = {
              metric_name              = "Percentage CPU"
              metric_resource_id       = ""
              operator                 = "GreaterThan"
              statistic                = "Average"
              time_aggregation         = "Average"
              time_grain               = "PT1M"
              time_window              = "PT5M"
              threshold                = 70
              metric_namespace         = "microsoft.compute/virtualmachinescalesets"
              divide_by_instance_count = false
            }

            scale_action = {
              direction = "Increase"
              type      = "ChangeCount"
              value     = "1"
              cooldown  = "PT5M"
            }
          },

          # ---------- SCALE IN ----------
          {
            metric_trigger = {
              metric_name              = "Percentage CPU"
              metric_resource_id       = ""
              operator                 = "LessThan"
              statistic                = "Average"
              time_aggregation         = "Average"
              time_grain               = "PT1M"
              time_window              = "PT10M"
              threshold                = 30
              metric_namespace         = "microsoft.compute/virtualmachinescalesets"
              divide_by_instance_count = false
            }

            scale_action = {
              direction = "Decrease"
              type      = "ChangeCount"
              value     = "1"
              cooldown  = "PT10M"
            }
          }
        ]
      },

      {
        name = "business-hours-profile"

        capacity = {
          default = 2
          minimum = 2
          maximum = 5
        }

        recurrence = {
          timezone = "India Standard Time"
          days     = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
          hours    = [9]
          minutes  = [0]
        }
      }
    ]

    # ---------------- NOTIFICATION ----------------
    # notification = {
    #   email = {
    #     send_to_subscription_administrator    = true
    #     send_to_subscription_co_administrator = false
    #     custom_emails = [
    #       "devops@company.com",
    #       "alerts@company.com"
    #     ]
    #   }

    #   webhook = [
    #     {
    #       service_uri = "https://hooks.company.com/autoscale"
    #       properties = {
    #         environment = "dev"
    #         app         = "frontend"
    #       }
    #     }
    #   ]
    # }

    predictive = {
      scale_mode      = "Enabled"
      look_ahead_time = "PT30M"
    }

    tags = {
      environment = "dev"
      application = "backend"
      owner       = "devops"
    }
  }

  vmss_frontend_autoscale = {
    name                = "dev-vmss-01-autoscale"
    resource_group_name = "dev_rg_01"
    location            = "West US 2"
    vmss_name           = "dev-vmss-01"

    # VMSS Resource ID
    target_resource_id = ""

    enabled = true
    profile = [
      {
        name = "default"
        capacity = {
          default = 1
          minimum = 1
          maximum = 5
        }

        rule = [
          # ---------- SCALE OUT ----------
          {
            metric_trigger = {
              metric_name              = "Percentage CPU"
              metric_resource_id       = ""
              operator                 = "GreaterThan"
              statistic                = "Average"
              time_aggregation         = "Average"
              time_grain               = "PT1M"
              time_window              = "PT5M"
              threshold                = 70
              metric_namespace         = "microsoft.compute/virtualmachinescalesets"
              divide_by_instance_count = false
            }

            scale_action = {
              direction = "Increase"
              type      = "ChangeCount"
              value     = "1"
              cooldown  = "PT5M"
            }
          },

          # ---------- SCALE IN ----------
          {
            metric_trigger = {
              metric_name              = "Percentage CPU"
              metric_resource_id       = ""
              operator                 = "LessThan"
              statistic                = "Average"
              time_aggregation         = "Average"
              time_grain               = "PT1M"
              time_window              = "PT10M"
              threshold                = 30
              metric_namespace         = "microsoft.compute/virtualmachinescalesets"
              divide_by_instance_count = false
            }

            scale_action = {
              direction = "Decrease"
              type      = "ChangeCount"
              value     = "1"
              cooldown  = "PT10M"
            }
          }
        ]
      },

      {
        name = "business-hours-profile"

        capacity = {
          default = 2
          minimum = 2
          maximum = 6
        }

        recurrence = {
          timezone = "India Standard Time"
          days     = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
          hours    = [9]
          minutes  = [0]
        }
      }
    ]

    # ---------------- NOTIFICATION ----------------
    # notification = {
    #   email = {
    #     send_to_subscription_administrator    = true
    #     send_to_subscription_co_administrator = false
    #     custom_emails = [
    #       "devops@company.com",
    #       "alerts@company.com"
    #     ]
    #   }

    #   webhook = [
    #     {
    #       service_uri = "https://hooks.company.com/autoscale"
    #       properties = {
    #         environment = "dev"
    #         app         = "frontend"
    #       }
    #     }
    #   ]
    # }

    predictive = {
      scale_mode      = "Enabled"
      look_ahead_time = "PT30M"
    }

    tags = {
      environment = "dev"
      application = "frontend"
      owner       = "devops"
    }
  }
}

# Application Gateways

application_gateways = {

  appgw_frontend = {
    name                 = "dev-appgw-frontend"
    resource_group_name  = "dev_rg_01"
    location             = "West US 2"
    virtual_network_name = "dev-vnet-01"
    subnet_name          = "subnet-04"
    pip_name             = "dev-pip-01"

    sku = {
      name     = "Standard_v2"
      tier     = "Standard_v2"
      capacity = 2
    }

    backend_address_pool = [
      {
        name = "frontend-vmss-pool"
      }
    ]

    probe = [
      {
        name                = "frontend-health-probe"
        protocol            = "Http"
        path                = "/"
        interval            = 30
        timeout             = 30
        unhealthy_threshold = 3
        port                = 80
      }
    ]

    backend_http_settings = [
      {
        name                  = "frontend-http-settings"
        cookie_based_affinity = "Disabled"
        port                  = 80
        protocol              = "Http"
        request_timeout       = 30
        probe_name            = "frontend-health-probe"
      }
    ]

    frontend_ip_configuration = [
      {
        name                 = "public-frontend"
        public_ip_address_id = ""
      }
    ]

    frontend_port = [
      {
        name = "http-port"
        port = 80
      }
    ]

    gateway_ip_configuration = [
      {
        name      = "appgw-ipcfg"
        subnet_id = ""
      }
    ]

    http_listener = [
      {
        name                           = "http-listener"
        frontend_ip_configuration_name = "public-frontend"
        frontend_port_name             = "http-port"
        protocol                       = "Http"
      }
    ]

    request_routing_rule = [
      {
        name                       = "frontend-rule"
        rule_type                  = "Basic"
        http_listener_name         = "http-listener"
        backend_address_pool_name  = "frontend-vmss-pool"
        backend_http_settings_name = "frontend-http-settings"
        priority                   = 100
      }
    ]

    global = {
      request_buffering_enabled  = true
      response_buffering_enabled = true
    }

    autoscale_configuration = {
      min_capacity = 2
      max_capacity = 5
    }

    tags = {
      environment = "dev"
      application = "frontend"
      owner       = "devops"
    }
  }
}



























