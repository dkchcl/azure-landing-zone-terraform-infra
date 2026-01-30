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
        body         = optional(string)
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




