# Outputs for the Azure Log Analytics Workspace module - exposes workspace details, solutions, and query configurations
output "log_analytics_workspace" {
  description = "The Log Analytics Workspace resource"
  value       = azurerm_log_analytics_workspace.this
}

output "log_analytics_solutions" {
  description = "Map of deployed Log Analytics solutions"
  value = {
    for k, v in azurerm_log_analytics_solution.this : k => v
  }
}

output "data_export_rules" {
  description = "Map of data export rules"
  value = {
    for k, v in azurerm_log_analytics_data_export_rule.this : k => v
  }
}

output "saved_searches" {
  description = "Map of saved searches"
  value = {
    for k, v in azurerm_log_analytics_saved_search.this : k => v
  }
}

output "query_packs" {
  description = "Map of query packs"
  value = {
    for k, v in azurerm_log_analytics_query_pack.this : k => v
  }
}

output "query_pack_queries" {
  description = "Map of query pack queries"
  value = {
    for k, v in azurerm_log_analytics_query_pack_query.this : k => v
  }
} 