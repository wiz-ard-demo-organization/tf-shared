locals {
  # Simple naming logic
  resource_types = {
    azuread_application = {
      slug = "sp"
    }
    azurerm_resource_group = {
      slug = "rg"
    }
    azurerm_storage_account = {
      separator         = ""
      organization_code = true
      slug              = "sa"
    }
    azurerm_key_vault = {
      separator         = ""
      organization_code = true
      slug              = "kv"
    }
    azurerm_log_analytics_workspace = {
      slug = "log"
    }
    azurerm_role_assignment = {
      slug = "ra"
    }
    azurerm_virtual_network = {
      slug = "vnet"
    }
    azurerm_subnet = {
      slug = "snet"
    }
    azurerm_network_security_group = {
      slug = "nsg"
    }
    azurerm_route_table = {
      slug = "rt"
    }
    azurerm_virtual_network_peering = {
      slug = "peer"
    }
    azurerm_network_interface = {
      slug = "nic"
    }
    azurerm_public_ip = {
      slug = "pip"
    }
    azurerm_linux_virtual_machine = {
      slug = "vm"
    }
  }
  
  # Build the name components
  slug = local.resource_types[var.resource_type].slug
  app_code = var.global_settings.prefix
  env_code = var.global_settings.environment  
  location_code = var.global_settings.region
  key_part = var.key
  instance = "001"
  
  # Generate the resource name
  resource_name = "${local.slug}-${local.app_code}-${local.key_part}-${local.env_code}-${local.location_code}-${local.instance}"
}
