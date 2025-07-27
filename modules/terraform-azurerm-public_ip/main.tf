// Module to create an Azure Public IP resource with customizable settings.
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
  resource_type   = "azurerm_public_ip"
}

locals {
  resource_group = can(var.settings.resource_group.state_key) ? try(var.remote_states[var.settings.resource_group.state_key].resource_groups[var.settings.resource_group.key], null) : try(var.resource_groups[var.settings.resource_group.key], null)
}

// Create an Azure Public IP resource with the provided configuration.
resource "azurerm_public_ip" "this" {
  name                    = try(var.settings.name, var.public_ip != null ? var.public_ip.name : null, module.name.result)
  location                = try(var.settings.location, var.global_settings.location_name, var.public_ip != null ? var.public_ip.location : null)
  resource_group_name     = try(var.settings.resource_group_name, local.resource_group.name, var.public_ip != null ? var.public_ip.resource_group_name : null)
  allocation_method       = try(var.settings.allocation_method, var.public_ip.allocation_method)
  sku                     = try(var.settings.sku, var.public_ip != null ? var.public_ip.sku : null)
  sku_tier                = try(var.settings.sku_tier, var.public_ip != null ? var.public_ip.sku_tier : null)
  zones                   = try(var.settings.zones, var.public_ip != null ? var.public_ip.zones : null)
  domain_name_label       = try(var.settings.domain_name_label, var.public_ip != null ? var.public_ip.domain_name_label : null)
  idle_timeout_in_minutes = try(var.settings.idle_timeout_in_minutes, var.public_ip != null ? var.public_ip.idle_timeout_in_minutes : null)
  ip_version              = try(var.settings.ip_version, var.public_ip != null ? var.public_ip.ip_version : null)
  ip_tags                 = try(var.settings.ip_tags, var.public_ip != null ? var.public_ip.ip_tags : null)
  public_ip_prefix_id     = try(var.settings.public_ip_prefix_id, var.public_ip != null ? var.public_ip.public_ip_prefix_id : null)
  reverse_fqdn            = try(var.settings.reverse_fqdn, var.public_ip != null ? var.public_ip.reverse_fqdn : null)
  edge_zone               = try(var.settings.edge_zone, var.public_ip != null ? var.public_ip.edge_zone : null)
  ddos_protection_mode    = try(var.settings.ddos_protection_mode, var.public_ip != null ? var.public_ip.ddos_protection_mode : null)
  ddos_protection_plan_id = try(var.settings.ddos_protection_plan_id, var.public_ip != null ? var.public_ip.ddos_protection_plan_id : null)

  tags = var.tags
} 