output "role_assignment_ids" {
  description = "Map of role assignment names to their IDs"
  value       = { for k, v in azurerm_role_assignment.this : k => v.id }
}

output "role_assignment_principal_ids" {
  description = "Map of role assignment names to their principal IDs"
  value       = { for k, v in azurerm_role_assignment.this : k => v.principal_id }
}

output "role_assignment_scopes" {
  description = "Map of role assignment names to their scopes"
  value       = { for k, v in azurerm_role_assignment.this : k => v.scope }
}

output "role_assignment_details" {
  description = "Detailed information about all role assignments"
  value = {
    for k, v in azurerm_role_assignment.this : k => {
      id                   = v.id
      scope                = v.scope
      role_definition_name = v.role_definition_name
      role_definition_id   = v.role_definition_id
      principal_id         = v.principal_id
      principal_type       = v.principal_type
      condition            = v.condition
      condition_version    = v.condition_version
      description          = v.description
    }
  }
} 