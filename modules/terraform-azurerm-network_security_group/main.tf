# Module for creating and managing Azure Network Security Groups with associated security rules
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

module "name" {
  source          = "../_global/modules/naming"
  key             = var.key
  settings        = var.settings
  global_settings = var.global_settings
  client_config   = var.client_config
  remote_states   = var.remote_states
  resource_type   = "azurerm_network_security_group"
}

locals {
  resource_group = can(var.settings.resource_group.state_key) ? try(var.remote_states[var.settings.resource_group.state_key].resource_groups[var.settings.resource_group.key], null) : try(var.resource_groups[var.settings.resource_group.key], null)
  # Handle both settings.security_rules and network_security_group.security_rules formats
  security_rules = try(var.settings.security_rules, var.network_security_group.security_rules, {})
}

# Create the Network Security Group resource with configurable security rules for network traffic control
resource "azurerm_network_security_group" "this" {
  name                = try(var.settings.name, var.network_security_group.name, module.name.result)
  resource_group_name = try(var.settings.resource_group_name, local.resource_group.name, var.network_security_group.resource_group_name)
  location            = try(var.settings.location, var.global_settings.location_name, var.network_security_group.location)

  tags = var.tags
}

# Create individual security rules associated with the NSG for granular traffic control
resource "azurerm_network_security_rule" "this" {
  for_each = local.security_rules

  name                                       = each.value.name
  resource_group_name                        = azurerm_network_security_group.this.resource_group_name
  network_security_group_name                = azurerm_network_security_group.this.name
  description                                = try(each.value.description, null)
  protocol                                   = each.value.protocol
  source_port_range                          = try(each.value.source_port_range, null)
  source_port_ranges                         = try(each.value.source_port_ranges, null)
  destination_port_range                     = try(each.value.destination_port_range, null)
  destination_port_ranges                    = try(each.value.destination_port_ranges, null)
  source_address_prefix                      = try(each.value.source_address_prefix, null)
  source_address_prefixes                    = try(each.value.source_address_prefixes, null)
  source_application_security_group_ids      = try(each.value.source_application_security_group_ids, null)
  destination_address_prefix                 = try(each.value.destination_address_prefix, null)
  destination_address_prefixes               = try(each.value.destination_address_prefixes, null)
  destination_application_security_group_ids = try(each.value.destination_application_security_group_ids, null)
  access                                     = each.value.access
  priority                                   = each.value.priority
  direction                                  = each.value.direction
} 