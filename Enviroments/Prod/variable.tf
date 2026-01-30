# Variable for RGs
variable "rg_name" {
  type = map(object({
    name       = string
    location   = string
    managed_by = optional(string)
    tags       = optional(map(string))
  }))
}

# Variable for virtual networks 

variable "vnet_name" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)

    bgp_community                  = optional(string)
    dns_servers                    = optional(list(string))
    edge_zone                      = optional(string) # Edge zone (for latency-sensitive workloads)
    flow_timeout_in_minutes        = optional(number)
    private_endpoint_vnet_policies = optional(string)

    ddos_protection_plan = optional(object({
      id     = string
      enable = string
    }))

    encryption = optional(object({
      enforcement = string
    }))

    ip_address_pool = optional(object({ # Optional IP address pool (alternative to address_space)
      id                     = string
      number_of_ip_addresses = string
    }))
    tags = optional(map(string))
  }))
}

# Variable for Subnets

variable "subnets" {
  description = "Map of subnets to create."
  type = map(object({
    subnet_name                                   = string
    resource_group_name                           = string
    virtual_network_name                          = string
    address_prefixes                              = optional(list(string))
    default_outbound_access_enabled               = optional(bool, true)
    private_endpoint_network_policies             = optional(string, "Disabled")
    private_link_service_network_policies_enabled = optional(bool, true)
    sharing_scope                                 = optional(string)
    service_endpoints                             = optional(list(string))
    service_endpoint_policy_ids                   = optional(list(string))

    delegation = optional(object({
      name = string
      service_delegation = list(object({
        name    = string
        actions = optional(list(string))
      }))
    }))

    ip_address_pool = optional(object({
      id                     = string
      number_of_ip_addresses = string
    }))

  }))
}

# Variable for Public IPs

variable "public_ip" {
  description = "Arguments for creating an Azure Public IP resource."
  type = map(object({
    pip_name                = string
    resource_group_name     = string
    location                = string
    allocation_method       = string
    zones                   = optional(list(string))
    ddos_protection_mode    = optional(string)
    ddos_protection_plan_id = optional(string)
    domain_name_label       = optional(string)
    domain_name_label_scope = optional(string)
    edge_zone               = optional(string)
    idle_timeout_in_minutes = optional(number)
    ip_tags                 = optional(map(string))
    ip_version              = optional(string)
    public_ip_prefix_id     = optional(string)
    reverse_fqdn            = optional(string)
    sku                     = optional(string)
    sku_tier                = optional(string)
    tags                    = optional(map(string))
  }))
}

#Variable for NSGs

variable "nsgs" {
  type = map(object({
    nsg_name            = string
    location            = string
    resource_group_name = string

    security_rule = optional(list(object({
      name                         = string
      priority                     = number
      direction                    = string
      access                       = string
      protocol                     = string
      description                  = optional(string)
      source_port_range            = optional(string)
      destination_port_range       = optional(string)
      source_address_prefix        = optional(string)
      destination_address_prefix   = optional(string)
      source_port_ranges           = optional(list(string))
      destination_port_ranges      = optional(list(string))
      source_address_prefixes      = optional(list(string))
      destination_address_prefixes = optional(list(string))
    })))
    tags = optional(map(string))
  }))
}

# Variable for Subnet_nsg_association

variable "subnet_nsg_nic_assoc" {

}

# Variable for Bastion Host

# variable "bastion_hosts" {
#   description = "Map of Bastion Hosts to create"
#   type = map(object({
#     bastion_host_name         = string
#     resource_group_name       = string
#     location                  = string
#     virtual_network_name      = optional(string)
#     subnet_name               = optional(string)
#     pip_name                  = optional(string)
#     copy_paste_enabled        = optional(bool, true)
#     file_copy_enabled         = optional(bool, false)
#     sku                       = optional(string, "Basic")
#     ip_connect_enabled        = optional(bool, false)
#     kerberos_enabled          = optional(bool, false)
#     scale_units               = optional(number, 2)
#     shareable_link_enabled    = optional(bool, false)
#     tunneling_enabled         = optional(bool, false)
#     session_recording_enabled = optional(bool, false)
#     tags                      = optional(map(string), {})
#     zones                     = optional(list(string), null)
#     ip_configuration = object({
#       name = string
#     })
#   }))
# }

# Variable for Key Vaults & Key Vault Secrets

variable "key_vaults" {
  description = "Azure Key Vault configurations"
  type = map(object({
    key_vault_name                  = string
    location                        = string
    resource_group_name             = string
    sku_name                        = string
    enabled_for_disk_encryption     = optional(bool, false)
    soft_delete_retention_days      = optional(number, 90)
    purge_protection_enabled        = optional(bool, false)
    public_network_access_enabled   = optional(bool, true)
    enabled_for_deployment          = optional(bool, false)
    enabled_for_template_deployment = optional(bool, false)
    rbac_authorization_enabled      = optional(bool, false)
    tags                            = optional(map(string), {})

    access_policy = optional(object({
      application_id          = optional(string)
      certificate_permissions = optional(list(string))
      key_permissions         = optional(list(string))
      secret_permissions      = optional(list(string))
      storage_permissions     = optional(list(string))
    }))

    network_acls = optional(object({
      bypass                     = string
      default_action             = string
      ip_rules                   = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
    }), null)

  }))
}

variable "key_vault_secrets" {
  type = map(object({
    secret_name         = string
    secret_value        = string
    key_vault_name      = optional(string)
    resource_group_name = optional(string)
    value_wo            = optional(string)
    value_wo_version    = optional(number)
    content_type        = optional(string)
    not_before_date     = optional(string)
    expiration_date     = optional(string)
    tags                = optional(map(string))
  }))
}

# Variable for NICs 

variable "nics" {
  type = map(object({
    name                 = string
    location             = string
    resource_group_name  = string
    virtual_network_name = optional(string)
    subnet_name          = optional(string)
    pip_name             = optional(string)

    ip_configuration = map(object({
      name                                               = string
      private_ip_address_allocation                      = string
      private_ip_address_version                         = optional(string)
      gateway_load_balancer_frontend_ip_configuration_id = optional(string)
      primary                                            = optional(bool)
      private_ip_address                                 = optional(string)
    }))

    auxiliary_mode                 = optional(string)
    auxiliary_sku                  = optional(string)
    dns_servers                    = optional(list(string))
    edge_zone                      = optional(string)
    ip_forwarding_enabled          = optional(bool)
    accelerated_networking_enabled = optional(bool)
    internal_dns_name_label        = optional(string)
    tags                           = optional(map(string))
  }))
}

# VARIABLE FOR STORAGE ACCOUNTS

# variable "storage_accounts" {
#   description = "Azure Storage Accounts with every supported argument and child block."
#   type = map(object({

#     # ---------- REQUIRED ----------
#     name                     = string
#     resource_group_name      = string
#     location                 = string
#     account_tier             = string
#     account_replication_type = string

#     # ---------- OPTIONAL ----------
#     account_kind                      = optional(string, "StorageV2")
#     provisioned_billing_model_version = optional(string)
#     cross_tenant_replication_enabled  = optional(bool, false)
#     access_tier                       = optional(string, "Hot")
#     edge_zone                         = optional(string)
#     https_traffic_only_enabled        = optional(bool, true)
#     min_tls_version                   = optional(string, "TLS1_2")
#     allow_nested_items_to_be_public   = optional(bool, true)
#     shared_access_key_enabled         = optional(bool, true)
#     public_network_access_enabled     = optional(bool, true)
#     default_to_oauth_authentication   = optional(bool, false)
#     is_hns_enabled                    = optional(bool, false)
#     nfsv3_enabled                     = optional(bool, false)
#     large_file_share_enabled          = optional(bool, false)
#     local_user_enabled                = optional(bool, true)
#     queue_encryption_key_type         = optional(string, "Service")
#     table_encryption_key_type         = optional(string, "Service")
#     infrastructure_encryption_enabled = optional(bool, false)
#     allowed_copy_scope                = optional(string)
#     sftp_enabled                      = optional(bool, false)
#     dns_endpoint_type                 = optional(string, "Standard")
#     tags                              = optional(map(string), {})

#     # ---------- CHILD BLOCKS ----------
#     custom_domain = optional(object({
#       name          = string
#       use_subdomain = optional(bool)
#     }))

#     customer_managed_key = optional(object({
#       key_vault_key_id          = optional(string)
#       managed_hsm_key_id        = optional(string)
#       user_assigned_identity_id = string
#     }))

#     identity = optional(object({
#       type         = string
#       identity_ids = optional(list(string))
#     }))

#     network_rules = optional(object({
#       default_action             = string
#       bypass                     = optional(list(string))
#       ip_rules                   = optional(list(string))
#       virtual_network_subnet_ids = optional(list(string))
#       private_link_access = optional(list(object({
#         endpoint_resource_id = string
#         endpoint_tenant_id   = optional(string)
#       })))
#     }))

#     blob_properties = optional(object({
#       versioning_enabled            = optional(bool)
#       change_feed_enabled           = optional(bool)
#       change_feed_retention_in_days = optional(number)
#       default_service_version       = optional(string)
#       last_access_time_enabled      = optional(bool)

#       delete_retention_policy = optional(object({
#         days                     = optional(number)
#         permanent_delete_enabled = optional(bool)
#       }))

#       restore_policy = optional(object({
#         days = number
#       }))

#       container_delete_retention_policy = optional(object({
#         days = optional(number)
#       }))

#       cors_rule = optional(list(object({
#         allowed_headers    = list(string)
#         allowed_methods    = list(string)
#         allowed_origins    = list(string)
#         exposed_headers    = list(string)
#         max_age_in_seconds = number
#       })))
#     }))

#     queue_properties = optional(object({
#       cors_rule = optional(list(object({
#         allowed_headers    = list(string)
#         allowed_methods    = list(string)
#         allowed_origins    = list(string)
#         exposed_headers    = list(string)
#         max_age_in_seconds = number
#       })))

#       logging = optional(object({
#         delete                = bool
#         read                  = bool
#         write                 = bool
#         version               = string
#         retention_policy_days = optional(number)
#       }))

#       minute_metrics = optional(object({
#         enabled               = bool
#         version               = string
#         include_apis          = optional(bool)
#         retention_policy_days = optional(number)
#       }))

#       hour_metrics = optional(object({
#         enabled               = bool
#         version               = string
#         include_apis          = optional(bool)
#         retention_policy_days = optional(number)
#       }))
#     }))

#     static_website = optional(object({
#       index_document     = optional(string)
#       error_404_document = optional(string)
#     }))

#     share_properties = optional(object({
#       cors_rule = optional(list(object({
#         allowed_headers    = list(string)
#         allowed_methods    = list(string)
#         allowed_origins    = list(string)
#         exposed_headers    = list(string)
#         max_age_in_seconds = number
#       })))

#       retention_policy = optional(object({
#         days = optional(number)
#       }))

#       smb = optional(object({
#         versions                        = optional(list(string))
#         authentication_types            = optional(list(string))
#         kerberos_ticket_encryption_type = optional(list(string))
#         channel_encryption_type         = optional(list(string))
#         multichannel_enabled            = optional(bool)
#       }))
#     }))

#     immutability_policy = optional(object({
#       allow_protected_append_writes = bool
#       state                         = string
#       period_since_creation_in_days = number
#     }))

#     sas_policy = optional(object({
#       expiration_period = string
#       expiration_action = optional(string)
#     }))

#     azure_files_authentication = optional(object({
#       directory_type                 = string
#       default_share_level_permission = optional(string)
#       active_directory = optional(object({
#         domain_name         = string
#         domain_guid         = string
#         domain_sid          = optional(string)
#         storage_sid         = optional(string)
#         forest_name         = optional(string)
#         netbios_domain_name = optional(string)
#       }))
#     }))

#     routing = optional(object({
#       publish_internet_endpoints  = optional(bool)
#       publish_microsoft_endpoints = optional(bool)
#       choice                      = optional(string)
#     }))
#   }))
# }


# Variable for SQL Server

# variable "sql_servers" {
#   description = "Map of SQL Servers to create"
#   type = map(object({
#     # Required
#     name                = string
#     resource_group_name = string
#     location            = string
#     version             = string
#     key_vault_name      = optional(string)
#     secret_name         = optional(string)
#     secret_password     = optional(string)

#     # Optional
#     administrator_login_password_wo              = optional(string)
#     administrator_login_password_wo_version      = optional(number)
#     connection_policy                            = optional(string)
#     express_vulnerability_assessment_enabled     = optional(bool)
#     transparent_data_encryption_key_vault_key_id = optional(string)
#     minimum_tls_version                          = optional(string)
#     public_network_access_enabled                = optional(bool)
#     outbound_network_restriction_enabled         = optional(bool)
#     primary_user_assigned_identity_id            = optional(string)
#     tags                                         = optional(map(string))

#     azuread_administrator = optional(object({
#       login_username              = string
#       object_id                   = string
#       tenant_id                   = optional(string)
#       azuread_authentication_only = optional(bool)
#     }))

#     identity = optional(object({
#       type         = string
#       identity_ids = optional(list(string))
#     }))

#   }))
# }

# # Variable for SQL Databases

# variable "sql_databases" {
#   description = "Map of SQL databases to create with all required and optional arguments"
#   type = map(object({
#     db_name                     = string
#     sql_server_name             = optional(string)
#     resource_group_name         = optional(string)
#     auto_pause_delay_in_minutes = optional(number)
#     create_mode                 = optional(string)
#     import = optional(object({
#       storage_uri                  = string
#       storage_key                  = string
#       storage_key_type             = string
#       administrator_login          = string
#       administrator_login_password = string
#       authentication_type          = string
#       storage_account_id           = optional(string)
#     }))
#     creation_source_database_id    = optional(string)
#     collation                      = optional(string)
#     elastic_pool_id                = optional(string)
#     enclave_type                   = optional(string)
#     geo_backup_enabled             = optional(bool)
#     maintenance_configuration_name = optional(string)
#     ledger_enabled                 = optional(bool)
#     license_type                   = optional(string)
#     long_term_retention_policy = optional(object({
#       weekly_retention  = optional(string)
#       monthly_retention = optional(string)
#       yearly_retention  = optional(string)
#       week_of_year      = optional(number)
#     }))
#     max_size_gb                           = optional(number)
#     min_capacity                          = optional(number)
#     restore_point_in_time                 = optional(string)
#     recover_database_id                   = optional(string)
#     recovery_point_id                     = optional(string)
#     restore_dropped_database_id           = optional(string)
#     restore_long_term_retention_backup_id = optional(string)
#     read_replica_count                    = optional(number)
#     read_scale                            = optional(bool)
#     sample_name                           = optional(string)
#     short_term_retention_policy = optional(object({
#       retention_days           = number
#       backup_interval_in_hours = optional(number)
#     }))
#     sku_name             = optional(string)
#     storage_account_type = optional(string)
#     threat_detection_policy = optional(object({
#       state                      = optional(string)
#       disabled_alerts            = optional(list(string))
#       email_account_admins       = optional(string)
#       email_addresses            = optional(list(string))
#       retention_days             = optional(number)
#       storage_account_access_key = optional(string)
#       storage_endpoint           = optional(string)
#     }))
#     identity = optional(object({
#       type         = string
#       identity_ids = list(string)
#     }))
#     transparent_data_encryption_enabled                        = optional(bool)
#     transparent_data_encryption_key_vault_key_id               = optional(string)
#     transparent_data_encryption_key_automatic_rotation_enabled = optional(bool)
#     zone_redundant                                             = optional(bool)
#     secondary_type                                             = optional(string)
#     tags                                                       = optional(map(string))
#   }))
#   default = {}
# }

# Variable for Internal Load Balancer

variable "load_balancers" {
  description = "Map of Load Balancers"
  type = map(object({
    lb_name              = string
    resource_group_name  = string
    location             = string
    edge_zone            = optional(string)
    sku                  = optional(string, "Standard")
    sku_tier             = optional(string, "Regional")
    tags                 = optional(map(string))
    virtual_network_name = optional(string)
    subnet_name          = optional(string)
    pip_name             = optional(string)
    frontend_ip_configuration = optional(map(object({
      name                                               = string
      zones                                              = optional(list(string))
      gateway_load_balancer_frontend_ip_configuration_id = optional(string)
      private_ip_address                                 = optional(string)
      private_ip_address_allocation                      = optional(string)
      private_ip_address_version                         = optional(string)
      public_ip_prefix_id                                = optional(string)
    })))

    # Variable for Backend Address Pools
    ba_pool_name       = string
    synchronous_mode   = optional(string)
    virtual_network_id = optional(string)
    tunnel_interface = optional(map(object({
      identifier = string
      type       = string
      protocol   = string
      port       = number
    })))

    # Variable for lb_nat_pool
    lb_nat_pool_name     = string
    protocol             = string
    frontend_port_start  = optional(number)
    frontend_port_end    = optional(number)
    natpool_backend_port = number

    # Variable for lb_probes
    lb_probes_name      = string
    port                = number
    probe_protocol      = optional(string, "Tcp")
    probe_threshold     = optional(number, 1)
    request_path        = optional(string)
    interval_in_seconds = optional(number, 15)
    number_of_probes    = optional(number, 2)

    # Variable for lb_rules
    lb_rules_name                  = string
    frontend_ip_configuration_name = string
    lbrule_protocol                = string
    frontend_port                  = number
    backend_port                   = number
    floating_ip_enabled            = optional(bool, false)
    idle_timeout_in_minutes        = optional(number, 4)
    load_distribution              = optional(string, "Default")
    disable_outbound_snat          = optional(bool, false)
    tcp_reset_enabled              = optional(bool, false)
  }))
}

# Variable for VMSS

variable "virtual_machine_scale_sets" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = string
    # admin_username       = string
    # admin_password       = optional(string)
    virtual_network_name = optional(string)
    subnet_name          = optional(string)
    nsg_name             = optional(string)
    key_vault_name       = optional(string)
    secret_name          = optional(string)
    secret_password      = optional(string)
    app_gateway_name     = optional(string)
    load_balancer_name   = optional(string)
    backend_pool_name    = optional(string)

    network_interface = list(object({
      name    = string
      primary = optional(bool)

      enable_accelerated_networking = optional(bool)
      enable_ip_forwarding          = optional(bool)
      dns_servers                   = optional(list(string))
      auxiliary_mode                = optional(string)
      auxiliary_sku                 = optional(string)

      ip_configuration = list(object({
        name    = string
        primary = optional(bool)
        version = optional(string)
        # application_gateway_backend_address_pool_ids = optional(list(string))
        # load_balancer_backend_address_pool_ids       = optional(list(string))
        # load_balancer_inbound_nat_rules_ids          = optional(list(string))
        # application_security_group_ids               = optional(list(string))

        public_ip_address = optional(object({
          name                    = string
          domain_name_label       = optional(string)
          idle_timeout_in_minutes = optional(number)
          public_ip_prefix_id     = optional(string)
          version                 = optional(string)

          ip_tag = optional(list(object({
            tag  = string
            type = string
          })))
        }))
      }))
    }))

    os_disk = object({
      caching                   = string
      storage_account_type      = string
      disk_size_gb              = optional(number)
      write_accelerator_enabled = optional(bool)

      disk_encryption_set_id           = optional(string)
      secure_vm_disk_encryption_set_id = optional(string)
      security_encryption_type         = optional(string)

      diff_disk_settings = optional(object({
        option    = string
        placement = optional(string)
      }))
    })

    source_image_id = optional(string)

    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }))

    instances = optional(number)

    additional_capabilities = optional(object({
      ultra_ssd_enabled = optional(bool)
    }))

    admin_ssh_key = optional(list(object({
      username   = string
      public_key = string
    })))

    automatic_os_upgrade_policy = optional(object({
      enable_automatic_os_upgrade = bool
      disable_automatic_rollback  = bool
    }))

    automatic_instance_repair = optional(object({
      enabled      = bool
      grace_period = optional(string)
      action       = optional(string)
    }))

    boot_diagnostics = optional(object({
      storage_account_uri = optional(string)
    }))

    capacity_reservation_group_id = optional(string)
    computer_name_prefix          = optional(string)
    custom_data                   = optional(string)

    data_disk = optional(list(object({
      name                           = optional(string)
      lun                            = number
      disk_size_gb                   = number
      caching                        = string
      create_option                  = optional(string)
      storage_account_type           = string
      disk_encryption_set_id         = optional(string)
      write_accelerator_enabled      = optional(bool)
      ultra_ssd_disk_iops_read_write = optional(number)
      ultra_ssd_disk_mbps_read_write = optional(number)
    })))

    disable_password_authentication                   = optional(bool)
    do_not_run_extensions_on_overprovisioned_machines = optional(bool)
    edge_zone                                         = optional(string)
    encryption_at_host_enabled                        = optional(bool)

    extension = optional(list(object({
      name                       = string
      publisher                  = string
      type                       = string
      type_handler_version       = string
      auto_upgrade_minor_version = optional(bool)
      automatic_upgrade_enabled  = optional(bool)
      force_update_tag           = optional(string)
      provision_after_extensions = optional(list(string))
      settings                   = optional(string)
      protected_settings         = optional(string)

      protected_settings_from_key_vault = optional(object({
        secret_url      = string
        source_vault_id = string
      }))
    })))

    extension_operations_enabled = optional(bool)
    extensions_time_budget       = optional(string)
    eviction_policy              = optional(string)

    gallery_application = optional(list(object({
      version_id             = string
      configuration_blob_uri = optional(string)
      order                  = optional(number)
      tag                    = optional(string)
    })))

    health_probe_id = optional(string)
    host_group_id   = optional(string)

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))

    max_bid_price = optional(number)
    overprovision = optional(bool)
    plan = optional(object({
      name      = string
      publisher = string
      product   = string
    }))

    platform_fault_domain_count  = optional(number)
    priority                     = optional(string)
    provision_vm_agent           = optional(bool)
    proximity_placement_group_id = optional(string)

    resilient_vm_creation_enabled = optional(bool)
    resilient_vm_deletion_enabled = optional(bool)

    rolling_upgrade_policy = optional(object({
      max_batch_instance_percent              = number
      max_unhealthy_instance_percent          = number
      max_unhealthy_upgraded_instance_percent = number
      pause_time_between_batches              = string
      cross_zone_upgrades_enabled             = optional(bool)
      prioritize_unhealthy_instances_enabled  = optional(bool)
      maximum_surge_instances_enabled         = optional(bool)
    }))

    scale_in = optional(object({
      rule                   = optional(string)
      force_deletion_enabled = optional(bool)
    }))

    secret = optional(list(object({
      key_vault_id = string
      certificate = list(object({
        url = string
      }))
    })))

    secure_boot_enabled    = optional(bool)
    single_placement_group = optional(bool)

    spot_restore = optional(object({
      enabled = optional(bool)
      timeout = optional(string)
    }))

    tags = optional(map(string))

    termination_notification = optional(object({
      enabled = bool
      timeout = optional(string)
    }))

    upgrade_mode = optional(string)
    user_data    = optional(string)
    vtpm_enabled = optional(bool)
    zone_balance = optional(bool)
    zones        = optional(list(string))

  }))
}

# Variable for VMSS Monitor Autoscale Settings

variable "vmss_autoscale_settings" {
  description = "Autoscale settings for Azure resources (VMSS, App Service, etc.)"
  type = map(object({

    # ---------------- REQUIRED ----------------
    name                = string
    resource_group_name = string
    location            = string
    target_resource_id  = string
    vmss_name           = optional(string)

    profile = list(object({
      name = string

      capacity = object({
        default = number
        minimum = number
        maximum = number
      })

      rule = optional(list(object({
        metric_trigger = object({
          metric_name              = string
          metric_resource_id       = string
          operator                 = string
          statistic                = string
          time_aggregation         = string
          time_grain               = string
          time_window              = string
          threshold                = number
          metric_namespace         = optional(string)
          divide_by_instance_count = optional(bool)

          dimensions = optional(list(object({
            name     = string
            operator = string
            values   = list(string)
          })))
        })

        scale_action = object({
          direction = string
          type      = string
          value     = string
          cooldown  = string
        })
      })))

      fixed_date = optional(object({
        start    = string
        end      = string
        timezone = optional(string)
      }))

      recurrence = optional(object({
        timezone = optional(string)
        days     = list(string)
        hours    = list(number)
        minutes  = list(number)
      }))
    }))

    # ---------------- OPTIONAL ----------------
    enabled = optional(bool)

    notification = optional(object({
      email = optional(object({
        send_to_subscription_administrator    = optional(bool)
        send_to_subscription_co_administrator = optional(bool)
        custom_emails                         = optional(list(string))
      }))

      webhook = optional(list(object({
        service_uri = string
        properties  = optional(map(string))
      })))
    }))

    predictive = optional(object({
      scale_mode      = string
      look_ahead_time = optional(string)
    }))

    tags = optional(map(string))

  }))
}

# Variable for Application Gateway

variable "application_gateways" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    location             = string
    virtual_network_name = optional(string)
    subnet_name          = optional(string)
    pip_name             = optional(string)

    backend_address_pool = list(object({
      name         = string
      fqdns        = optional(list(string))
      ip_addresses = optional(list(string))
    }))

    backend_http_settings = list(object({
      name                                 = string
      cookie_based_affinity                = string
      port                                 = number
      protocol                             = string
      affinity_cookie_name                 = optional(string)
      host_name                            = optional(string)
      path                                 = optional(string)
      pick_host_name_from_backend_address  = optional(bool)
      probe_name                           = optional(string)
      request_timeout                      = optional(number)
      trusted_root_certificate_names       = optional(list(string))
      dedicated_backend_connection_enabled = optional(bool)

      authentication_certificate = optional(list(object({
        name = string
      })))

      connection_draining = optional(object({
        enabled           = bool
        drain_timeout_sec = number
      }))
    }))

    frontend_ip_configuration = list(object({
      name                            = string
      private_ip_address              = optional(string)
      private_ip_address_allocation   = optional(string)
      private_link_configuration_name = optional(string)
    }))

    frontend_port = list(object({
      name = string
      port = number
    }))

    gateway_ip_configuration = list(object({
      name      = string
      subnet_id = string
    }))

    http_listener = list(object({
      name                           = string
      frontend_ip_configuration_name = string
      frontend_port_name             = string
      protocol                       = string
      host_name                      = optional(string)
      host_names                     = optional(list(string))
      require_sni                    = optional(bool)
      ssl_certificate_name           = optional(string)
      firewall_policy_id             = optional(string)
      ssl_profile_name               = optional(string)

      custom_error_configuration = optional(list(object({
        status_code           = string
        custom_error_page_url = string
      })))
    }))

    request_routing_rule = list(object({
      name                        = string
      rule_type                   = string
      http_listener_name          = string
      backend_address_pool_name   = optional(string)
      backend_http_settings_name  = optional(string)
      redirect_configuration_name = optional(string)
      rewrite_rule_set_name       = optional(string)
      url_path_map_name           = optional(string)
      priority                    = optional(number)
    }))

    sku = object({
      name     = string
      tier     = string
      capacity = optional(number)
    })

    # ---------------- OPTIONAL ----------------
    fips_enabled = optional(bool)

    global = optional(object({
      request_buffering_enabled  = bool
      response_buffering_enabled = bool
    }))

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))

    private_link_configuration = optional(list(object({
      name = string
      ip_configuration = list(object({
        name                          = string
        subnet_id                     = string
        private_ip_address_allocation = string
        primary                       = bool
        private_ip_address            = optional(string)
      }))
    })))

    zones = optional(list(string))

    trusted_client_certificate = optional(list(object({
      name = string
      data = string
    })))

    ssl_profile = optional(list(object({
      name                                 = string
      trusted_client_certificate_names     = optional(list(string))
      verify_client_cert_issuer_dn         = optional(bool)
      verify_client_certificate_revocation = optional(string)

      ssl_policy = optional(object({
        disabled_protocols   = optional(list(string))
        policy_type          = optional(string)
        policy_name          = optional(string)
        cipher_suites        = optional(list(string))
        min_protocol_version = optional(string)
      }))
    })))

    authentication_certificate = optional(list(object({
      name = string
      data = string
    })))

    trusted_root_certificate = optional(list(object({
      name                = string
      data                = optional(string)
      key_vault_secret_id = optional(string)
    })))

    ssl_policy = optional(object({
      disabled_protocols   = optional(list(string))
      policy_type          = optional(string)
      policy_name          = optional(string)
      cipher_suites        = optional(list(string))
      min_protocol_version = optional(string)
    }))

    enable_http2                      = optional(bool)
    force_firewall_policy_association = optional(bool)

    probe = optional(list(object({
      name                                      = string
      protocol                                  = string
      path                                      = string
      interval                                  = number
      timeout                                   = number
      unhealthy_threshold                       = number
      host                                      = optional(string)
      port                                      = optional(number)
      pick_host_name_from_backend_http_settings = optional(bool)
      minimum_servers                           = optional(number)

      match = optional(object({
        status_codes = list(string)
        body        = optional(string)
      }))
    })))

    ssl_certificate = optional(list(object({
      name                = string
      data                = optional(string)
      password            = optional(string)
      key_vault_secret_id = optional(string)
    })))

    url_path_map = optional(list(object({
      name                                = string
      default_backend_address_pool_name   = optional(string)
      default_backend_http_settings_name  = optional(string)
      default_redirect_configuration_name = optional(string)
      default_rewrite_rule_set_name       = optional(string)

      path_rule = list(object({
        name                        = string
        paths                       = list(string)
        backend_address_pool_name   = optional(string)
        backend_http_settings_name  = optional(string)
        redirect_configuration_name = optional(string)
        rewrite_rule_set_name       = optional(string)
        firewall_policy_id          = optional(string)
      }))
    })))

    waf_configuration = optional(object({
      enabled                  = bool
      firewall_mode            = string
      rule_set_type            = optional(string)
      rule_set_version         = string
      file_upload_limit_mb     = optional(number)
      request_body_check       = optional(bool)
      max_request_body_size_kb = optional(number)

      disabled_rule_group = optional(list(object({
        rule_group_name = string
        rules           = optional(list(number))
      })))

      exclusion = optional(list(object({
        match_variable          = string
        selector_match_operator = optional(string)
        selector                = optional(string)
      })))
    }))

    custom_error_configuration = optional(list(object({
      status_code           = string
      custom_error_page_url = string
    })))

    firewall_policy_id = optional(string)

    redirect_configuration = optional(list(object({
      name                 = string
      redirect_type        = string
      target_listener_name = optional(string)
      target_url           = optional(string)
      include_path         = optional(bool)
      include_query_string = optional(bool)
    })))

    autoscale_configuration = optional(object({
      min_capacity = number
      max_capacity = optional(number)
    }))

    rewrite_rule_set = optional(list(object({
      name = string

      rewrite_rule = optional(list(object({
        name          = string
        rule_sequence = number

        condition = optional(list(object({
          variable    = string
          pattern     = string
          ignore_case = optional(bool)
          negate      = optional(bool)
        })))

        request_header_configuration = optional(list(object({
          header_name  = string
          header_value = string
        })))

        response_header_configuration = optional(list(object({
          header_name  = string
          header_value = string
        })))

        url = optional(object({
          path         = optional(string)
          query_string = optional(string)
          components   = optional(list(string))
          reroute      = optional(bool)
        }))
      })))
    })))

    tags = optional(map(string))

  }))
}
































