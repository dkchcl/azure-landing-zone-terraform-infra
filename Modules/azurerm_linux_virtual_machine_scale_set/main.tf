resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  for_each = var.virtual_machine_scale_sets

  name                            = each.value.name
  location                        = each.value.location
  resource_group_name             = each.value.resource_group_name
  sku                             = each.value.sku
  instances                       = lookup(each.value, "instances", null)
  admin_username                  = data.azurerm_key_vault_secret.kvs[each.key].value
  admin_password                  = data.azurerm_key_vault_secret.kvs1[each.key].value
  disable_password_authentication = lookup(each.value, "disable_password_authentication", null)

  computer_name_prefix = lookup(each.value, "computer_name_prefix", null)
  custom_data                   = lookup(each.value, "custom_data", null)
  user_data                     = lookup(each.value, "user_data", null)
  edge_zone                     = lookup(each.value, "edge_zone", null)
  encryption_at_host_enabled    = lookup(each.value, "encryption_at_host_enabled", null)
  extension_operations_enabled  = lookup(each.value, "extension_operations_enabled", null)
  extensions_time_budget        = lookup(each.value, "extensions_time_budget", null)
  eviction_policy               = lookup(each.value, "eviction_policy", null)
  health_probe_id               = lookup(each.value, "health_probe_id", null)
  max_bid_price                 = lookup(each.value, "max_bid_price", null)
  overprovision                 = lookup(each.value, "overprovision", null)
  platform_fault_domain_count   = lookup(each.value, "platform_fault_domain_count", null)
  priority                      = lookup(each.value, "priority", null)
  provision_vm_agent            = lookup(each.value, "provision_vm_agent", null)
  proximity_placement_group_id  = lookup(each.value, "proximity_placement_group_id", null)
  capacity_reservation_group_id = lookup(each.value, "capacity_reservation_group_id", null)
  host_group_id                 = lookup(each.value, "host_group_id", null)
  secure_boot_enabled           = lookup(each.value, "secure_boot_enabled", null)
  vtpm_enabled                  = lookup(each.value, "vtpm_enabled", null)
  single_placement_group        = lookup(each.value, "single_placement_group", null)
  upgrade_mode                  = lookup(each.value, "upgrade_mode", null)
  zone_balance                  = lookup(each.value, "zone_balance", null)
  zones                         = lookup(each.value, "zones", null)
  # resilient_vm_creation_enabled                     = lookup(each.value, "resilient_vm_creation_enabled", null)
  # resilient_vm_deletion_enabled                     = lookup(each.value, "resilient_vm_deletion_enabled", null)
  do_not_run_extensions_on_overprovisioned_machines = lookup(each.value, "do_not_run_extensions_on_overprovisioned_machines", null)
  source_image_id                                   = lookup(each.value, "source_image_id", null)

  dynamic "source_image_reference" {
    for_each = each.value.source_image_reference == null ? [] : [each.value.source_image_reference]
    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  dynamic "additional_capabilities" {
    for_each = each.value.additional_capabilities == null ? [] : [each.value.additional_capabilities]
    content {
      ultra_ssd_enabled = lookup(additional_capabilities.value, "ultra_ssd_enabled", null)
    }
  }

  dynamic "admin_ssh_key" {
    for_each = each.value.admin_ssh_key == null ? [] : each.value.admin_ssh_key
    content {
      username   = admin_ssh_key.value.username
      public_key = admin_ssh_key.value.public_key
    }
  }

  dynamic "automatic_os_upgrade_policy" {
    for_each = each.value.automatic_os_upgrade_policy == null ? [] : [each.value.automatic_os_upgrade_policy]
    content {
      enable_automatic_os_upgrade = automatic_os_upgrade_policy.value.enable_automatic_os_upgrade
      disable_automatic_rollback  = automatic_os_upgrade_policy.value.disable_automatic_rollback
    }
  }

  dynamic "automatic_instance_repair" {
    for_each = each.value.automatic_instance_repair == null ? [] : [each.value.automatic_instance_repair]
    content {
      enabled      = automatic_instance_repair.value.enabled
      grace_period = lookup(automatic_instance_repair.value, "grace_period", null)
      action       = lookup(automatic_instance_repair.value, "action", null)
    }
  }

  dynamic "boot_diagnostics" {
    for_each = each.value.boot_diagnostics == null ? [] : [each.value.boot_diagnostics]
    content {
      storage_account_uri = lookup(boot_diagnostics.value, "storage_account_uri", null)
    }
  }

  dynamic "identity" {
    for_each = each.value.identity == null ? [] : [each.value.identity]
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  dynamic "network_interface" {
    for_each = each.value.network_interface
    content {
      name                          = network_interface.value.name
      primary                       = lookup(network_interface.value, "primary", null)
      enable_accelerated_networking = lookup(network_interface.value, "enable_accelerated_networking", null)
      enable_ip_forwarding          = lookup(network_interface.value, "enable_ip_forwarding", null)
      dns_servers                   = lookup(network_interface.value, "dns_servers", null)
    network_security_group_id     = data.azurerm_network_security_group.nsg[each.key].id
    auxiliary_mode                = lookup(network_interface.value, "auxiliary_mode", null)
    auxiliary_sku                 = lookup(network_interface.value, "auxiliary_sku", null)

    dynamic "ip_configuration" {
        for_each = network_interface.value.ip_configuration
        content {
          name      = ip_configuration.value.name
          primary   = lookup(ip_configuration.value, "primary", null)
          subnet_id = data.azurerm_subnet.subnet[each.key].id
          version   = lookup(ip_configuration.value, "version", null)

          # application_gateway_backend_address_pool_ids = [data.azurerm_application_gateway.appgw[each.key].backend_address_pool[0].id]
          application_gateway_backend_address_pool_ids = lookup(each.value, "appgw_backend_pool_ids", null)
          load_balancer_backend_address_pool_ids       = lookup(each.value, "lb_backend_pool_ids", null)

          #   load_balancer_inbound_nat_rules_ids =
          #     lookup(ip_configuration.value, "load_balancer_inbound_nat_rules_ids", null)

          #   application_security_group_ids =
          #     lookup(ip_configuration.value, "application_security_group_ids", null)

          dynamic "public_ip_address" {
            for_each = ip_configuration.value.public_ip_address == null ? [] : [ip_configuration.value.public_ip_address]
            content {
              name                    = public_ip_address.value.name
              domain_name_label       = lookup(public_ip_address.value, "domain_name_label", null)
              idle_timeout_in_minutes = lookup(public_ip_address.value, "idle_timeout_in_minutes", null)
              public_ip_prefix_id     = lookup(public_ip_address.value, "public_ip_prefix_id", null)
              version                 = lookup(public_ip_address.value, "version", null)

              dynamic "ip_tag" {
                for_each = lookup(public_ip_address.value, "ip_tag", null) == null ? [] : public_ip_address.value.ip_tag
                content {
                  tag  = ip_tag.value.tag
                  type = ip_tag.value.type
                }
              }
            }
          }
        }
      }
    }
  }

  os_disk {
    caching                          = each.value.os_disk.caching
    storage_account_type             = each.value.os_disk.storage_account_type
    disk_size_gb                     = lookup(each.value.os_disk, "disk_size_gb", null)
    write_accelerator_enabled        = lookup(each.value.os_disk, "write_accelerator_enabled", null)
    disk_encryption_set_id           = lookup(each.value.os_disk, "disk_encryption_set_id", null)
    secure_vm_disk_encryption_set_id = lookup(each.value.os_disk, "secure_vm_disk_encryption_set_id", null)
    security_encryption_type         = lookup(each.value.os_disk, "security_encryption_type", null)

    dynamic "diff_disk_settings" {
      for_each = lookup(each.value.os_disk, "diff_disk_settings", null) == null ? [] : [each.value.os_disk.diff_disk_settings]
      content {
        option    = diff_disk_settings.value.option
        placement = lookup(diff_disk_settings.value, "placement", null)
      }
    }
  }

  dynamic "data_disk" {
    for_each = each.value.data_disk == null ? [] : each.value.data_disk
    content {
      name                           = lookup(data_disk.value, "name", null)
      lun                            = data_disk.value.lun
      disk_size_gb                   = data_disk.value.disk_size_gb
      caching                        = data_disk.value.caching
      create_option                  = lookup(data_disk.value, "create_option", null)
      storage_account_type           = data_disk.value.storage_account_type
      disk_encryption_set_id         = lookup(data_disk.value, "disk_encryption_set_id", null)
      write_accelerator_enabled      = lookup(data_disk.value, "write_accelerator_enabled", null)
      ultra_ssd_disk_iops_read_write = lookup(data_disk.value, "ultra_ssd_disk_iops_read_write", null)
      ultra_ssd_disk_mbps_read_write = lookup(data_disk.value, "ultra_ssd_disk_mbps_read_write", null)
    }
  }

  tags = lookup(each.value, "tags", null)

  # 🚀 Nginx Install script
#   custom_data = base64encode(<<EOF
# #!/bin/bash
# sudo apt-get update -y
# sudo apt-get install -y nginx
# sudo systemctl enable nginx
# sudo systemctl start nginx

# cat <<EOT | sudo tee /var/www/html/index.html
# <!DOCTYPE html>
# <html lang="en">
# <head>
#   <meta charset="UTF-8" />
#   <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
#   <title>🚀 DevOps Mastery Course</title>
#   <style>
#     body {
#       font-family: 'Segoe UI', sans-serif;
#       background: linear-gradient(to right, #f2f2f2, #e6f7ff);
#       margin: 0;
#       padding: 0;
#       color: #333;
#     }
#     header {
#       background-color: #007acc;
#       color: white;
#       padding: 20px 40px;
#       text-align: center;
#     }
#     header h1 {
#       font-size: 36px;
#     }
#     section {
#       padding: 30px 40px;
#     }
#     .section-title {
#       font-size: 28px;
#       margin-bottom: 10px;
#       color: #007acc;
#     }
#     .course-details, .syllabus, .instructor, .contact {
#       background-color: #ffffff;
#       padding: 20px;
#       border-radius: 10px;
#       margin-bottom: 30px;
#       box-shadow: 0px 4px 10px rgba(0,0,0,0.1);
#     }
#     ul {
#       padding-left: 20px;
#     }
#     .contact form {
#       display: flex;
#       flex-direction: column;
#     }
#     .contact input, .contact textarea {
#       margin-bottom: 15px;
#       padding: 10px;
#       border: 1px solid #ccc;
#       border-radius: 6px;
#     }
#     .contact button {
#       background-color: #007acc;
#       color: white;
#       padding: 10px;
#       border: none;
#       border-radius: 6px;
#       cursor: pointer;
#       font-size: 16px;
#     }
#     .contact button:hover {
#       background-color: #005f99;
#     }
#     footer {
#       text-align: center;
#       padding: 15px;
#       background-color: #007acc;
#       color: white;
#     }
#   </style>
# </head>
# <body>
#   <header>
#     <h1>🚀 DevOps Mastery Course</h1>
#     <p>📚 Learn DevOps from Scratch & Become a Pro!</p>
#   </header>
#   <section>
#     <div class="course-details">
#       <h2 class="section-title">📋 Course Overview</h2>
#       <p>Welcome to the <strong>DevOps Mastery Course</strong> 🌟 — your gateway to mastering automation, CI/CD, Docker, Kubernetes, Jenkins, and more! Perfect for developers, sysadmins, and IT enthusiasts who want to streamline development and operations. 👨‍💻👩‍💻</p>
#     </div>
#     <div class="syllabus">
#       <h2 class="section-title">📚 Syllabus</h2>
#       <ul>
#         <li>🔧 Introduction to DevOps</li>
#         <li>🐧 Linux Basics for DevOps</li>
#         <li>🛠️ CI/CD Pipelines</li>
#         <li>🐳 Docker & Containers</li>
#         <li>☸️ Kubernetes Basics</li>
#         <li>🔐 Security & Monitoring</li>
#         <li>🧪 Testing and Automation</li>
#         <li>☁️ Cloud Integration (AWS, Azure)</li>
#       </ul>
#     </div>
#     <div class="instructor">
#       <h2 class="section-title">👨‍🏫 Instructor</h2>
#       <p><strong>Mr. Ashish Kumar</strong> – Senior DevOps Engineer with 17+ years of experience in cloud, automation & infrastructure management. 🧠✨</p>
#       <p><strong>Mr. Aman Gupta</strong> – Senior DevOps Engineer with 15+ years of experience in cloud, automation & infrastructure management. 🧠✨</p>
#     </div>   
#     <div class="course-details">
#       <h2 class="section-title">⏳ Duration & Mode</h2>
#       <ul>
#         <li>🕒 Duration: 8 Weeks</li>
#         <li>🌐 Mode: Online (Live + Recordings)</li>
#         <li>📅 Next Batch: 1st October 2025</li>
#       </ul>
#     </div>
#     <div class="contact">
#       <h2 class="section-title">📞 Contact Us</h2>
#       <form action="#" method="POST">
#         <input type="text" name="name" placeholder="👤 Your Name" required />
#         <input type="email" name="email" placeholder="📧 Your Email" required />
#         <input type="tel" name="phone" placeholder="📱 Phone Number" />
#         <textarea name="message" rows="4" placeholder="💬 Your Message"></textarea>
#         <button type="submit">📨 Submit</button>
#       </form>
#     </div>
#   </section>
#   <footer>
#     <p>© 2025 DevOps Academy 🚀 | Built with ❤️ by ChatGPT</p>
#   </footer>
# </body>
# </html>
# EOT
# EOF
#   )

}












