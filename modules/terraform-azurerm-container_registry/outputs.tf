output "container_registry" {
  description = "The complete Container Registry object"
  value       = azurerm_container_registry.this
  sensitive   = true
}

output "id" {
  description = "The ID of the Container Registry"
  value       = azurerm_container_registry.this.id
}

output "name" {
  description = "The Name of the Container Registry"
  value       = azurerm_container_registry.this.name
}

output "login_server" {
  description = "The URL that can be used to log into the container registry"
  value       = azurerm_container_registry.this.login_server
}

output "location" {
  description = "The Azure Region where the Container Registry exists"
  value       = azurerm_container_registry.this.location
}

output "resource_group_name" {
  description = "The name of the Resource Group in which the Container Registry exists"
  value       = azurerm_container_registry.this.resource_group_name
}

output "admin_username" {
  description = "The Username associated with the Container Registry Admin account - if the admin account is enabled"
  value       = azurerm_container_registry.this.admin_username
  sensitive   = true
}

output "admin_password" {
  description = "The Password associated with the Container Registry Admin account - if the admin account is enabled"
  value       = azurerm_container_registry.this.admin_password
  sensitive   = true
}

output "identity" {
  description = "The managed identity information of the Container Registry"
  value       = azurerm_container_registry.this.identity
} 