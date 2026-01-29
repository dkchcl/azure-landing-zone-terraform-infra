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
    # app_gateway_name     = optional(string)
    # load_balancer_name   = optional(string)
    # backend_pool_name    = optional(string)

    network_interface = list(object({
      name    = string
      primary = optional(bool)

      enable_accelerated_networking = optional(bool)
      enable_ip_forwarding          = optional(bool)
      dns_servers                   = optional(list(string))
      auxiliary_mode                = optional(string)
      auxiliary_sku                 = optional(string)

      ip_configuration = list(object({
        name                   = string
        primary                = optional(bool)
        version                = optional(string)
        appgw_backend_pool_ids = optional(list(string))
        lb_backend_pool_ids    = optional(list(string))

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











