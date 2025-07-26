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
  global_settings = var.global_settings
  resource_type   = "azurerm_monitor_diagnostic_setting"
}

# Create diagnostic settings to send logs and metrics to various destinations for monitoring and compliance
resource "azurerm_monitor_diagnostic_setting" "this" {
  name               = try(var.diagnostic_setting.name, module.name.result)
  target_resource_id = var.diagnostic_setting.target_resource_id

  # Destination configuration for diagnostic data
  log_analytics_workspace_id     = var.diagnostic_setting.log_analytics_workspace_id
  log_analytics_destination_type = var.diagnostic_setting.log_analytics_destination_type
  storage_account_id             = var.diagnostic_setting.storage_account_id
  eventhub_name                  = var.diagnostic_setting.eventhub_name
  eventhub_authorization_rule_id = var.diagnostic_setting.eventhub_authorization_rule_id
  partner_solution_id            = var.diagnostic_setting.partner_solution_id

  # Configure which logs to collect and their retention policies
  dynamic "enabled_log" {
    for_each = var.diagnostic_setting.enabled_log != null ? var.diagnostic_setting.enabled_log : []
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
    for_each = var.diagnostic_setting.metric != null ? var.diagnostic_setting.metric : []
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