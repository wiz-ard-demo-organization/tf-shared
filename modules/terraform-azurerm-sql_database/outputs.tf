output "sql_server" {
  description = "The SQL Server resource"
  value       = azurerm_mssql_server.this
}

output "sql_databases" {
  description = "Map of SQL databases"
  value = {
    for k, v in azurerm_mssql_database.this : k => v
  }
}

output "firewall_rules" {
  description = "Map of firewall rules"
  value = {
    for k, v in azurerm_mssql_firewall_rule.this : k => v
  }
}

output "virtual_network_rules" {
  description = "Map of virtual network rules"
  value = {
    for k, v in azurerm_mssql_virtual_network_rule.this : k => v
  }
}

output "extended_auditing_policy" {
  description = "The extended auditing policy configuration"
  value = var.extended_auditing_policy != null ? azurerm_mssql_server_extended_auditing_policy.this[0] : null
}

output "security_alert_policy" {
  description = "The security alert policy configuration"
  value = var.security_alert_policy != null ? azurerm_mssql_server_security_alert_policy.this[0] : null
}

output "vulnerability_assessment" {
  description = "The vulnerability assessment configuration"
  value = var.vulnerability_assessment != null ? azurerm_mssql_server_vulnerability_assessment.this[0] : null
}

output "elastic_pools" {
  description = "Map of elastic pools"
  value = {
    for k, v in azurerm_mssql_elastic_pool.this : k => v
  }
} 