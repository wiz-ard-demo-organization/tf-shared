output "policy_set_definition" {
  description = "The complete Azure Policy Set Definition resource"
  value       = azurerm_policy_set_definition.this
}

output "id" {
  description = "The ID of the Policy Set Definition"
  value       = azurerm_policy_set_definition.this.id
}

output "name" {
  description = "The name of the Policy Set Definition"
  value       = azurerm_policy_set_definition.this.name
}

output "display_name" {
  description = "The display name of the Policy Set Definition"
  value       = azurerm_policy_set_definition.this.display_name
}

output "policy_type" {
  description = "The type of the Policy Set Definition"
  value       = azurerm_policy_set_definition.this.policy_type
}

output "policy_definition_reference" {
  description = "The policy definition references within this initiative"
  value       = azurerm_policy_set_definition.this.policy_definition_reference
}
