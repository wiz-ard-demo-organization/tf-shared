output "role_assignments" {
  description = "Map of role assignments"
  value = {
    for k, v in azurerm_role_assignment.this : k => v
  }
} 