# Module for creating and managing Azure Network Security Groups
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
  global_settings = var.global_settings
  resource_type   = "azurerm_network_security_group"
}

# Create the Azure Network Security Group
resource "azurerm_network_security_group" "this" {
  name                = module.name.result
  location            = var.network_security_group.location
  resource_group_name = var.network_security_group.resource_group_name

  # Create security rules
  dynamic "security_rule" {
    for_each = var.network_security_group.security_rules != null ? var.network_security_group.security_rules : []
    content {
      name                                       = security_rule.value.name
      priority                                   = security_rule.value.priority
      direction                                  = security_rule.value.direction
      access                                     = security_rule.value.access
      protocol                                   = security_rule.value.protocol
      source_port_range                          = security_rule.value.source_port_range
      destination_port_range                     = security_rule.value.destination_port_range
      source_address_prefix                      = security_rule.value.source_address_prefix
      destination_address_prefix                 = security_rule.value.destination_address_prefix
      source_port_ranges                         = try(security_rule.value.source_port_ranges, null)
      destination_port_ranges                    = try(security_rule.value.destination_port_ranges, null)
      source_address_prefixes                    = try(security_rule.value.source_address_prefixes, null)
      destination_address_prefixes               = try(security_rule.value.destination_address_prefixes, null)
      source_application_security_group_ids      = try(security_rule.value.source_application_security_group_ids, null)
      destination_application_security_group_ids = try(security_rule.value.destination_application_security_group_ids, null)
      description                                = try(security_rule.value.description, null)
    }
  }

  tags = var.tags
} 