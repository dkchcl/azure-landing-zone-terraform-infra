# Resource Groups

rg_name = {
  rg1 = {
    name       = "prod_rg_01"
    location   = "West US 2"
    managed_by = "Terraform"
    tags = {
      project    = "tech-007"
      env        = "prod"
      team       = "prod-007"
      created_by = "Dinesh"
    }
  }
}

# Virtual Networks

vnet_name = {
  vnet1 = {
    name                = "prod-vnet-01"
    location            = "West US 2"
    resource_group_name = "prod_rg_01"
    address_space       = ["10.0.0.0/16"]
    tags = {
      env = "prod"
    }
  }
}

# Subnets

subnets = {
  subnet1 = {
    subnet_name          = "subnet-01"
    resource_group_name  = "prod_rg_01"
    virtual_network_name = "prod-vnet-01"
    address_prefixes     = ["10.0.1.0/24"]
  }

  subnet2 = {
    subnet_name          = "subnet-02"
    resource_group_name  = "prod_rg_01"
    virtual_network_name = "prod-vnet-01"
    address_prefixes     = ["10.0.2.0/24"]
  }

  subnet3 = {
    subnet_name          = "AzureBastionSubnet"
    resource_group_name  = "prod_rg_01"
    virtual_network_name = "prod-vnet-01"
    address_prefixes     = ["10.0.3.0/24"]
  }
}

# Public IP Addresses

public_ip = {
  "bastion_pip" = {
    pip_name            = "prod-pip-01"
    resource_group_name = "prod_rg_01"
    location            = "West US 2"
    allocation_method   = "Static"
    tags = {
      env = "prod"
      app = "bastion"
    }
  }
}

# Network Security Groups

nsgs = {
  nsg1 = {
    nsg_name            = "prodnsg01"
    location            = "West US 2"
    resource_group_name = "prod_rg_01"

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
      }
    ]

    tags = {
      env = "prod"
    }
  }

  nsg2 = {
    nsg_name            = "prodnsg02"
    location            = "West US 2"
    resource_group_name = "prod_rg_01"

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
    name                 = "prod-nic-01"
    location             = "West US 2"
    resource_group_name  = "prod_rg_01"
    virtual_network_name = "prod-vnet-01"
    subnet_name          = "subnet-01"
    ip_configuration = {
      ipconfig1 = {
        name                          = "ipconfig1"
        private_ip_address_allocation = "Dynamic"
      }
    }
  }

  nic2 = {
    name                 = "prod-nic-02"
    location             = "West US 2"
    resource_group_name  = "prod_rg_01"
    virtual_network_name = "prod-vnet-01"
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
    nsg_name             = "prodnsg01"
    virtual_network_name = "prod-vnet-01"
    subnet_name          = "subnet-01"
    resource_group_name  = "prod_rg_01"
    nic_name             = "prod-nic-01"
  }

  sub_nsg_assoc2 = {
    nsg_name             = "prodnsg02"
    virtual_network_name = "prod-vnet-01"
    subnet_name          = "subnet-02"
    resource_group_name  = "prod_rg_01"
    nic_name             = "prod-nic-02"
  }
}

# Bastion Host

bastion_hosts = {
  bastion1 = {
    bastion_host_name         = "prod-bastion-host"
    resource_group_name       = "prod_rg_01"
    location                  = "West US 2"
    sku                       = "Standard"
    virtual_network_name      = "prod-vnet-01"
    subnet_name               = "AzureBastionSubnet"
    pip_name                  = "prod-pip-03"
    copy_paste_enabled        = true
    file_copy_enabled         = true
    ip_connect_enabled        = true
    kerberos_enabled          = false
    scale_units               = 3
    shareable_link_enabled    = true
    tunneling_enabled         = true
    session_recording_enabled = false

    ip_configuration = {
      name = "bastion-ipconfig"
    }

    tags = {
      environment = "prod"
      project     = "bastion-prod"
    }
  }
}

# Key Vault and Key Vault Secrets

key_vaults = {
  kv1 = {
    key_vault_name              = "prodnewkv01"
    location                    = "West US 2"
    resource_group_name         = "prod_rg_01"
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

key_vault_secrets = {
  vm_users = {
    secret_name         = "vm-username"
    secret_value        = "adminuser"
    key_vault_name      = "prodnewkv01"
    resource_group_name = "prod_rg_01"
  }

  vm_pass = {
    secret_name         = "vm-password"
    secret_value        = "Bbpl@#123456"
    key_vault_name      = "prodnewkv01"
    resource_group_name = "prod_rg_01"
  }

  sql_user = {
    secret_name         = "db-username"
    secret_value        = "dbuser"
    key_vault_name      = "prodnewkv01"
    resource_group_name = "prod_rg_01"
  }

  sql_pass = {
    secret_name         = "db-password"
    secret_value        = "Bbpl@#123456"
    key_vault_name      = "prodnewkv01"
    resource_group_name = "prod_rg_01"
  }

}

# Virtual Machines

vms = {
  vm1 = {
    vm_name                         = "frontend-vm-01"
    location                        = "West US 2"
    resource_group_name             = "prod_rg_01"
    size                            = "Standard_B1s"
    nic_name                        = "prod-nic-01"
    key_vault_name                  = "prodnewkv01"
    secret_name                     = "vm-username"
    secret_password                 = "vm-password"
    disable_password_authentication = false

    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }

    tags = {
      environment = "prod"
      owner       = "team-app"
    }
  }

  vm2 = {
    vm_name                         = "backend-vm-01"
    location                        = "West US 2"
    resource_group_name             = "prod_rg_01"
    size                            = "Standard_B1s"
    nic_name                        = "prod-nic-02"
    key_vault_name                  = "prodnewkv01"
    secret_name                     = "vm-username"
    secret_password                 = "vm-password"
    disable_password_authentication = false

    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
  }
}

storage_accounts = {
  "stg1" = {
    name                     = "newstorageaccount011"
    resource_group_name      = "prod_rg_01"
    location                 = "West US 2"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Hot"
  }
}

sql_servers = {
  "server1" = {
    name                          = "prodnewsqlserver99"
    resource_group_name           = "prod_rg_01"
    location                      = "West US 2"
    version                       = "12.0"
    secret_name                   = "db-username"
    secret_password               = "db-password"
    key_vault_name                = "prodnewkv01"
    connection_policy             = "Default"
    minimum_tls_version           = "1.2"
    public_network_access_enabled = true
    tags                          = { Environment = "prod" }
  }
}

sql_databases = {
  "db1" = {
    db_name             = "proddb-01"
    sql_server_name     = "prodnewsqlserver99"
    resource_group_name = "prod_rg_01"
    sku_name            = "GP_Gen5_2"
    max_size_gb         = 5
    short_term_retention_policy = {
      retention_days = 7
    }
    threat_detection_policy = {
      state                = "Enabled"
      email_account_admins = "Enabled"
      retention_days       = 30
    }
  }
}






























