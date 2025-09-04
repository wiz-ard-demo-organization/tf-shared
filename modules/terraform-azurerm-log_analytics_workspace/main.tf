# Module for creating and managing Azure Log Analytics Workspace for centralized log collection and analysis
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
  resource_type   = "azurerm_log_analytics_workspace"
}

resource "azurerm_log_analytics_workspace" "this" {
  name                       = try(var.settings.name, module.name.result)
  location                   = try(var.settings.location, var.global_settings.location_name)
  resource_group_name        = try(var.settings.resource_group_name, local.resource_group.name)
  
  # Pricing and retention configuration
  sku                        = try(var.settings.sku, null)
  retention_in_days          = try(var.settings.retention_in_days, null)
  daily_quota_gb             = try(var.settings.daily_quota_gb, null)
  reservation_capacity_in_gb_per_day = try(var.settings.reservation_capacity_in_gb_per_day, null)
  
  # Network and security settings
  internet_ingestion_enabled = try(var.settings.internet_ingestion_enabled, null)
  internet_query_enabled     = try(var.settings.internet_query_enabled, null)
  
  # Data management configuration
  data_collection_rule_id    = try(var.settings.data_collection_rule_id, null)
  immediate_data_purge_on_30_days_enabled = try(var.settings.immediate_data_purge_on_30_days_enabled, null)
  cmk_for_query_forced       = try(var.settings.cmk_for_query_forced, null)

  # Managed identity configuration for secure access
  dynamic "identity" {
    for_each = try(var.settings.identity, null) != null ? [var.settings.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  tags = var.tags
} 