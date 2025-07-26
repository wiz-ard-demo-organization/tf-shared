output "storage_account" {
  description = "The Storage Account resource"
  value       = azurerm_storage_account.this
  sensitive   = true
}

output "storage_containers" {
  description = "Map of Storage Containers"
  value = {
    for k, v in azurerm_storage_container.this : k => v
  }
}

output "lifecycle_management_policy" {
  description = "The Storage Management Policy"
  value = var.lifecycle_management != null ? azurerm_storage_management_policy.this[0] : null
} 