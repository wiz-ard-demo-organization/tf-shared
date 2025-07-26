output "policy_assignment" {
  description = "The complete Azure Management Group Policy Assignment resource"
  value       = azurerm_management_group_policy_assignment.this
}

output "id" {
  description = "The ID of the Management Group Policy Assignment"
  value       = azurerm_management_group_policy_assignment.this.id
}

output "name" {
  description = "The name of the Management Group Policy Assignment"
  value       = azurerm_management_group_policy_assignment.this.name
}

output "display_name" {
  description = "The display name of the Management Group Policy Assignment"
  value       = azurerm_management_group_policy_assignment.this.display_name
}

output "principal_id" {
  description = "The Principal ID of the Policy Assignment for this Management Group"
  value       = try(azurerm_management_group_policy_assignment.this.identity[0].principal_id, null)
}

output "tenant_id" {
  description = "The Tenant ID of the Policy Assignment for this Management Group"
  value       = try(azurerm_management_group_policy_assignment.this.identity[0].tenant_id, null)
}

output "identity" {
  description = "The identity block of the Policy Assignment"
  value       = try(azurerm_management_group_policy_assignment.this.identity[0], null)
}
