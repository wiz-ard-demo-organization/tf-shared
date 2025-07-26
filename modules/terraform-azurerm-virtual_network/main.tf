terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_virtual_network" "this" {
  name                = var.virtual_network.name
  location            = var.virtual_network.location
  resource_group_name = var.virtual_network.resource_group_name
  address_space       = var.virtual_network.address_space
  dns_servers         = var.virtual_network.dns_servers
  edge_zone           = var.virtual_network.edge_zone
  flow_timeout_in_minutes = var.virtual_network.flow_timeout_in_minutes

  dynamic "ddos_protection_plan" {
    for_each = var.virtual_network.ddos_protection_plan != null ? [var.virtual_network.ddos_protection_plan] : []
    content {
      id     = ddos_protection_plan.value.id
      enable = ddos_protection_plan.value.enable
    }
  }

  dynamic "encryption" {
    for_each = var.virtual_network.encryption != null ? [var.virtual_network.encryption] : []
    content {
      enforcement = encryption.value.enforcement
    }
  }

  tags = var.tags
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                                          = each.value.name
  resource_group_name                           = var.virtual_network.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = each.value.address_prefixes
  private_endpoint_network_policies_enabled    = each.value.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
  service_endpoints                             = each.value.service_endpoints
  service_endpoint_policy_ids                   = each.value.service_endpoint_policy_ids

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
} 