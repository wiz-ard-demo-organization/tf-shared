# Module for configuring Azure Monitor Diagnostic Settings to collect and route platform logs and metrics from Azure resources
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
  resource_type   = "azurerm_monitor_diagnostic_setting"
}

# Create diagnostic settings to send logs and metrics to various destinations for monitoring and compliance
resource "azurerm_monitor_diagnostic_setting" "this" {
  name               = try(var.settings.name, module.name.result)
  target_resource_id = var.settings.target_resource_id

  # Destination configuration for diagnostic data
  log_analytics_workspace_id     = try(var.settings.log_analytics_workspace_id, null)
  log_analytics_destination_type = try(var.settings.log_analytics_destination_type, null)
  storage_account_id             = try(var.settings.storage_account_id, null)
  eventhub_name                  = try(var.settings.eventhub_name, null)
  eventhub_authorization_rule_id = try(var.settings.eventhub_authorization_rule_id, null)
  partner_solution_id            = try(var.settings.partner_solution_id, null)

  # Configure which logs to collect and their retention policies
  dynamic "enabled_log" {
    for_each = try(var.settings.enabled_log, [])
    content {
      category       = enabled_log.value.category
      category_group = enabled_log.value.category_group

      # Optional retention policy for log data
      dynamic "retention_policy" {
        for_each = enabled_log.value.retention_policy != null ? [enabled_log.value.retention_policy] : []
        content {
          enabled = retention_policy.value.enabled
          days    = retention_policy.value.days
        }
      }
    }
  }

  # Configure which metrics to collect and their retention policies
  dynamic "metric" {
    for_each = try(var.settings.metric, [])
    content {
      category = metric.value.category
      enabled  = metric.value.enabled

      # Optional retention policy for metric data
      dynamic "retention_policy" {
        for_each = metric.value.retention_policy != null ? [metric.value.retention_policy] : []
        content {
          enabled = retention_policy.value.enabled
          days    = retention_policy.value.days
        }
      }
    }
  }
} 