terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_log_analytics_workspace" "this" {
  name                       = var.log_analytics_workspace.name
  location                   = var.log_analytics_workspace.location
  resource_group_name        = var.log_analytics_workspace.resource_group_name
  sku                        = var.log_analytics_workspace.sku
  retention_in_days          = var.log_analytics_workspace.retention_in_days
  daily_quota_gb             = var.log_analytics_workspace.daily_quota_gb
  internet_ingestion_enabled = var.log_analytics_workspace.internet_ingestion_enabled
  internet_query_enabled     = var.log_analytics_workspace.internet_query_enabled
  reservation_capacity_in_gb_per_day = var.log_analytics_workspace.reservation_capacity_in_gb_per_day
  data_collection_rule_id    = var.log_analytics_workspace.data_collection_rule_id
  immediate_data_purge_on_30_days_enabled = var.log_analytics_workspace.immediate_data_purge_on_30_days_enabled
  local_authentication_disabled = var.log_analytics_workspace.local_authentication_disabled
  cmk_for_query_forced       = var.log_analytics_workspace.cmk_for_query_forced

  dynamic "identity" {
    for_each = var.log_analytics_workspace.identity != null ? [var.log_analytics_workspace.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  tags = var.tags
}

resource "azurerm_log_analytics_solution" "this" {
  for_each = var.log_analytics_solutions

  solution_name         = each.value.solution_name
  location              = var.log_analytics_workspace.location
  resource_group_name   = var.log_analytics_workspace.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.this.id
  workspace_name        = azurerm_log_analytics_workspace.this.name

  plan {
    publisher = each.value.plan.publisher
    product   = each.value.plan.product
  }

  tags = var.tags
}

resource "azurerm_log_analytics_data_export_rule" "this" {
  for_each = var.data_export_rules

  name                    = each.value.name
  resource_group_name     = var.log_analytics_workspace.resource_group_name
  workspace_resource_id   = azurerm_log_analytics_workspace.this.id
  destination_resource_id = each.value.destination_resource_id
  table_names             = each.value.table_names
  enabled                 = each.value.enabled
}

resource "azurerm_log_analytics_saved_search" "this" {
  for_each = var.saved_searches

  name                       = each.value.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  category                   = each.value.category
  display_name               = each.value.display_name
  query                      = each.value.query
  function_alias             = each.value.function_alias
  function_parameters        = each.value.function_parameters

  tags = var.tags
}

resource "azurerm_log_analytics_query_pack" "this" {
  for_each = var.query_packs

  name                = each.value.name
  location            = var.log_analytics_workspace.location
  resource_group_name = var.log_analytics_workspace.resource_group_name

  tags = var.tags
}

resource "azurerm_log_analytics_query_pack_query" "this" {
  for_each = var.query_pack_queries

  query_pack_id   = azurerm_log_analytics_query_pack.this[each.value.query_pack_key].id
  body            = each.value.body
  display_name    = each.value.display_name
  name            = each.value.name
  description     = each.value.description
  categories      = each.value.categories
  resource_types  = each.value.resource_types
  solutions       = each.value.solutions
  tags            = each.value.tags

  additional_settings_json = each.value.additional_settings_json
} 