output "diagnostic_setting_id" {
  description = "The ID of the Diagnostic Setting"
  value       = azurerm_monitor_diagnostic_setting.this.id
}

output "diagnostic_setting_name" {
  description = "The name of the Diagnostic Setting"
  value       = azurerm_monitor_diagnostic_setting.this.name
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace if configured"
  value       = var.diagnostic_setting.log_analytics_workspace_id
}

output "storage_account_id" {
  description = "The ID of the Storage Account if configured"
  value       = var.diagnostic_setting.storage_account_id
}

output "eventhub_authorization_rule_id" {
  description = "The ID of the Event Hub Authorization Rule if configured"
  value       = var.diagnostic_setting.eventhub_authorization_rule_id
} 