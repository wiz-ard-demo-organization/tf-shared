# Module for creating and managing Azure Container Registry with comprehensive configuration options including geo-replication, encryption, and network security
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
  resource_type   = "azurerm_container_registry"
}

locals {
  resource_group = can(var.settings.resource_group.state_key) ? try(var.remote_states[var.settings.resource_group.state_key].resource_groups[var.settings.resource_group.key], null) : try(var.resource_groups[var.settings.resource_group.key], null)
}

# Create the Azure Container Registry with specified configuration
resource "azurerm_container_registry" "this" {
  name                          = try(var.settings.name, var.container_registry != null ? var.container_registry.name : null, module.name.result)
  resource_group_name           = try(var.settings.resource_group_name, local.resource_group.name, var.container_registry != null ? var.container_registry.resource_group_name : null)
  location                      = try(var.settings.location, var.global_settings.location_name, var.container_registry != null ? var.container_registry.location : null)
  sku                           = try(var.settings.sku, var.container_registry != null ? var.container_registry.sku : null)
  admin_enabled                 = try(var.settings.admin_enabled, var.container_registry != null ? var.container_registry.admin_enabled : null)
  public_network_access_enabled = try(var.settings.public_network_access_enabled, var.container_registry != null ? var.container_registry.public_network_access_enabled : null)
  quarantine_policy_enabled     = try(var.settings.quarantine_policy_enabled, var.container_registry != null ? var.container_registry.quarantine_policy_enabled : null)
  zone_redundancy_enabled       = try(var.settings.zone_redundancy_enabled, var.container_registry != null ? var.container_registry.zone_redundancy_enabled : null)
  export_policy_enabled         = try(var.settings.export_policy_enabled, var.container_registry != null ? var.container_registry.export_policy_enabled : null)
  anonymous_pull_enabled        = try(var.settings.anonymous_pull_enabled, var.container_registry != null ? var.container_registry.anonymous_pull_enabled : null)
  data_endpoint_enabled         = try(var.settings.data_endpoint_enabled, var.container_registry != null ? var.container_registry.data_endpoint_enabled : null)
  network_rule_bypass_option    = try(var.settings.network_rule_bypass_option, var.container_registry != null ? var.container_registry.network_rule_bypass_option : null)

  # Configure geo-replication for Premium SKUs
  dynamic "georeplications" {
    for_each = try(var.settings.georeplications, [])
    content {
      location                  = georeplications.value.location
      regional_endpoint_enabled = georeplications.value.regional_endpoint_enabled
      zone_redundancy_enabled   = georeplications.value.zone_redundancy_enabled
      tags                      = georeplications.value.tags
    }
  }

  # Configure network access rules for Premium SKUs
  dynamic "network_rule_set" {
    for_each = try(var.settings.network_rule_set, var.container_registry != null ? var.container_registry.network_rule_set : null, null) != null ? [try(var.settings.network_rule_set, var.container_registry.network_rule_set)] : []
    content {
      default_action = network_rule_set.value.default_action

      # Configure IP access rules
      dynamic "ip_rule" {
        for_each = network_rule_set.value.ip_rule != null ? network_rule_set.value.ip_rule : []
        content {
          action   = ip_rule.value.action
          ip_range = ip_rule.value.ip_range
        }
      }
    }
  }

  # Configure managed identity for the container registry
  dynamic "identity" {
    for_each = try(var.settings.identity, var.container_registry != null ? var.container_registry.identity : null, null) != null ? [try(var.settings.identity, var.container_registry.identity)] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  # Configure customer-managed encryption for Premium SKUs
  dynamic "encryption" {
    for_each = try(var.settings.encryption, var.container_registry != null ? var.container_registry.encryption : null, null) != null ? [try(var.settings.encryption, var.container_registry.encryption)] : []
    content {
      key_vault_key_id   = encryption.value.key_vault_key_id
      identity_client_id = encryption.value.identity_client_id
    }
  }

  tags = var.tags
} 