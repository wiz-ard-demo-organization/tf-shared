terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name               = var.diagnostic_setting.name
  target_resource_id = var.diagnostic_setting.target_resource_id

  log_analytics_workspace_id     = var.diagnostic_setting.log_analytics_workspace_id
  log_analytics_destination_type = var.diagnostic_setting.log_analytics_destination_type
  storage_account_id             = var.diagnostic_setting.storage_account_id
  eventhub_name                  = var.diagnostic_setting.eventhub_name
  eventhub_authorization_rule_id = var.diagnostic_setting.eventhub_authorization_rule_id
  partner_solution_id            = var.diagnostic_setting.partner_solution_id

  dynamic "enabled_log" {
    for_each = var.diagnostic_setting.enabled_log != null ? var.diagnostic_setting.enabled_log : []
    content {
      category       = enabled_log.value.category
      category_group = enabled_log.value.category_group

      dynamic "retention_policy" {
        for_each = enabled_log.value.retention_policy != null ? [enabled_log.value.retention_policy] : []
        content {
          enabled = retention_policy.value.enabled
          days    = retention_policy.value.days
        }
      }
    }
  }

  dynamic "metric" {
    for_each = var.diagnostic_setting.metric != null ? var.diagnostic_setting.metric : []
    content {
      category = metric.value.category
      enabled  = metric.value.enabled

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