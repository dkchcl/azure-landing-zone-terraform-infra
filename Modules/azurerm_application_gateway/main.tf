resource "azurerm_application_gateway" "appgw" {
  for_each = var.application_gateways

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  fips_enabled                      = lookup(each.value, "fips_enabled", null)
  enable_http2                      = lookup(each.value, "enable_http2", null)
  firewall_policy_id                = lookup(each.value, "firewall_policy_id", null)
  force_firewall_policy_association = lookup(each.value, "force_firewall_policy_association", null)
  zones                             = lookup(each.value, "zones", null)

  dynamic "sku" {
    for_each = [each.value.sku]
    content {
      name     = sku.value.name
      tier     = sku.value.tier
      capacity = lookup(sku.value, "capacity", null)
    }
  }

  dynamic "global" {
    for_each = lookup(each.value, "global", null) == null ? [] : [each.value.global]
    content {
      request_buffering_enabled  = global.value.request_buffering_enabled
      response_buffering_enabled = global.value.response_buffering_enabled
    }
  }

  dynamic "identity" {
    for_each = lookup(each.value, "identity", null) == null ? [] : [each.value.identity]
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  dynamic "backend_address_pool" {
    for_each = each.value.backend_address_pool
    content {
      name         = backend_address_pool.value.name
      fqdns        = lookup(backend_address_pool.value, "fqdns", null)
      ip_addresses = lookup(backend_address_pool.value, "ip_addresses", null)
    }
  }

  dynamic "backend_http_settings" {
    for_each = each.value.backend_http_settings
    content {
      name                                = backend_http_settings.value.name
      cookie_based_affinity               = backend_http_settings.value.cookie_based_affinity
      port                                = backend_http_settings.value.port
      protocol                            = backend_http_settings.value.protocol
      affinity_cookie_name                = lookup(backend_http_settings.value, "affinity_cookie_name", null)
      host_name                           = lookup(backend_http_settings.value, "host_name", null)
      path                                = lookup(backend_http_settings.value, "path", null)
      pick_host_name_from_backend_address = lookup(backend_http_settings.value, "pick_host_name_from_backend_address", null)
      probe_name                          = lookup(backend_http_settings.value, "probe_name", null)
      request_timeout                     = lookup(backend_http_settings.value, "request_timeout", null)
      trusted_root_certificate_names      = lookup(backend_http_settings.value, "trusted_root_certificate_names", null)
      # dedicated_backend_connection_enabled = lookup(backend_http_settings.value, "dedicated_backend_connection_enabled", null)

      dynamic "authentication_certificate" {
        for_each = lookup(backend_http_settings.value, "authentication_certificate", null) == null ? [] : backend_http_settings.value.authentication_certificate
        content {
          name = authentication_certificate.value.name
        }
      }

      dynamic "connection_draining" {
        for_each = lookup(backend_http_settings.value, "connection_draining", null) == null ? [] : [backend_http_settings.value.connection_draining]
        content {
          enabled           = connection_draining.value.enabled
          drain_timeout_sec = connection_draining.value.drain_timeout_sec
        }
      }
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = each.value.frontend_ip_configuration
    content {
      name                            = frontend_ip_configuration.value.name
      # subnet_id                       = data.azurerm_subnet.subnet[each.key].id
      private_ip_address              = lookup(frontend_ip_configuration.value, "private_ip_address", null)
      public_ip_address_id            = data.azurerm_public_ip.pip[each.key].id
      private_ip_address_allocation   = lookup(frontend_ip_configuration.value, "private_ip_address_allocation", null)
      private_link_configuration_name = lookup(frontend_ip_configuration.value, "private_link_configuration_name", null)
    }
  }

  dynamic "frontend_port" {
    for_each = each.value.frontend_port
    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  dynamic "gateway_ip_configuration" {
    for_each = each.value.gateway_ip_configuration
    content {
      name      = gateway_ip_configuration.value.name
      subnet_id = data.azurerm_subnet.subnet[each.key].id
    }
  }

  dynamic "http_listener" {
    for_each = each.value.http_listener
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
      host_name                      = lookup(http_listener.value, "host_name", null)
      host_names                     = lookup(http_listener.value, "host_names", null)
      require_sni                    = lookup(http_listener.value, "require_sni", null)
      ssl_certificate_name           = lookup(http_listener.value, "ssl_certificate_name", null)
      firewall_policy_id             = lookup(http_listener.value, "firewall_policy_id", null)
      ssl_profile_name               = lookup(http_listener.value, "ssl_profile_name", null)

      dynamic "custom_error_configuration" {
        for_each = lookup(http_listener.value, "custom_error_configuration", null) == null ? [] : http_listener.value.custom_error_configuration
        content {
          status_code           = custom_error_configuration.value.status_code
          custom_error_page_url = custom_error_configuration.value.custom_error_page_url
        }
      }
    }
  }

  dynamic "request_routing_rule" {
    for_each = each.value.request_routing_rule
    content {
      name                        = request_routing_rule.value.name
      rule_type                   = request_routing_rule.value.rule_type
      http_listener_name          = request_routing_rule.value.http_listener_name
      backend_address_pool_name   = lookup(request_routing_rule.value, "backend_address_pool_name", null)
      backend_http_settings_name  = lookup(request_routing_rule.value, "backend_http_settings_name", null)
      redirect_configuration_name = lookup(request_routing_rule.value, "redirect_configuration_name", null)
      rewrite_rule_set_name       = lookup(request_routing_rule.value, "rewrite_rule_set_name", null)
      url_path_map_name           = lookup(request_routing_rule.value, "url_path_map_name", null)
      priority                    = lookup(request_routing_rule.value, "priority", null)
    }
  }

  # dynamic "probe" {
  #   for_each = each.value.probe
  #   content {
  #     name                                      = probe.value.name
  #     protocol                                  = probe.value.protocol
  #     host                                      = lookup(probe.value, "host", null)
  #     path                                      = probe.value.path
  #     interval                                  = probe.value.interval
  #     timeout                                   = probe.value.timeout
  #     unhealthy_threshold                       = probe.value.unhealthy_threshold
  #     port                                      = probe.value.port
  #     pick_host_name_from_backend_http_settings = lookup(probe.value, "pick_host_name_from_backend_http_settings", null)
  #   }
  # }

  dynamic "probe" {
    for_each = lookup(each.value, "probes", [])

    content {
      name                                      = probe.value.name
      protocol                                  = probe.value.protocol
      host                                      = lookup(probe.value, "host", "127.0.0.1")
      path                                      = probe.value.path
      interval                                  = probe.value.interval
      timeout                                   = probe.value.timeout
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      port                                      = lookup(probe.value, "port", null)
      pick_host_name_from_backend_http_settings = false
      minimum_servers                           = lookup(probe.value, "minimum_servers", null)

      dynamic "match" {
        for_each = lookup(probe.value, "match", null) == null ? [] : [probe.value.match]
        content {
          status_code = match.value.status_codes
          body        = lookup(match.value, "body", null)
        }
      }
    }
  }

  tags = lookup(each.value, "tags", null)
}
















