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
  global_settings = var.global_settings
  resource_type   = "azurerm_log_analytics_workspace"
}

resource "azurerm_log_analytics_workspace" "this" {
  name                       = try(var.log_analytics_workspace.name, module.name.result)
  location                   = var.log_analytics_workspace.location
  resource_group_name        = var.log_analytics_workspace.resource_group_name
  
  # Pricing and retention configuration
  sku                        = var.log_analytics_workspace.sku
  retention_in_days          = var.log_analytics_workspace.retention_in_days
  daily_quota_gb             = var.log_analytics_workspace.daily_quota_gb
  reservation_capacity_in_gb_per_day = var.log_analytics_workspace.reservation_capacity_in_gb_per_day
  
  # Network and security settings
  internet_ingestion_enabled = var.log_analytics_workspace.internet_ingestion_enabled
  internet_query_enabled     = var.log_analytics_workspace.internet_query_enabled
  local_authentication_enabled = var.log_analytics_workspace.local_authentication_enabled
  
  # Data management configuration
  data_collection_rule_id    = var.log_analytics_workspace.data_collection_rule_id
  immediate_data_purge_on_30_days_enabled = var.log_analytics_workspace.immediate_data_purge_on_30_days_enabled
  cmk_for_query_forced       = var.log_analytics_workspace.cmk_for_query_forced

  # Managed identity configuration for secure access
  dynamic "identity" {
    for_each = var.log_analytics_workspace.identity != null ? [var.log_analytics_workspace.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  tags = var.tags
} 