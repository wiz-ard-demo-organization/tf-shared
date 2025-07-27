# Module for creating and managing Azure Virtual Networks with associated subnets and network configurations
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
  resource_type   = "azurerm_virtual_network"
}

locals {
  resource_group = can(var.settings.resource_group.state_key) ? try(var.remote_states[var.settings.resource_group.state_key].resource_groups[var.settings.resource_group.key], null) : try(var.resource_groups[var.settings.resource_group.key], null)
}

# Create the Azure Virtual Network
resource "azurerm_virtual_network" "this" {
  name                            = try(var.settings.name, var.virtual_network.name, module.name.result)
  resource_group_name             = try(var.settings.resource_group_name, local.resource_group.name, var.virtual_network.resource_group_name)
  location                        = try(var.settings.location, var.global_settings.location_name, var.virtual_network.location)
  address_space                   = try(var.settings.address_space, var.virtual_network.address_space)
  dns_servers                     = try(var.settings.dns_servers, var.virtual_network.dns_servers, [])
  edge_zone                       = try(var.settings.edge_zone, var.virtual_network != null ? var.virtual_network.edge_zone : null, null)
  flow_timeout_in_minutes         = try(var.settings.flow_timeout_in_minutes, var.virtual_network != null ? var.virtual_network.flow_timeout_in_minutes : null, null)
  bgp_community                   = try(var.settings.bgp_community, var.virtual_network != null ? var.virtual_network.bgp_community : null, null)

  # Optional DDoS protection plan
  dynamic "ddos_protection_plan" {
    for_each = try(var.settings.ddos_protection_plan, var.virtual_network != null ? var.virtual_network.ddos_protection_plan : null, null) != null ? [try(var.settings.ddos_protection_plan, var.virtual_network.ddos_protection_plan)] : []
    content {
      id     = ddos_protection_plan.value.id
      enable = ddos_protection_plan.value.enable
    }
  }

  # Optional encryption configuration
  dynamic "encryption" {
    for_each = try(var.settings.encryption, var.virtual_network != null ? var.virtual_network.encryption : null, null) != null ? [try(var.settings.encryption, var.virtual_network.encryption)] : []
    content {
      enforcement = encryption.value.enforcement
    }
  }

  tags = var.tags
}

 