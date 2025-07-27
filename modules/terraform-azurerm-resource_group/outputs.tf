output "resource_group" {
  description = "The complete resource group object"
  value       = azurerm_resource_group.this
}

output "id" {
  description = "The ID of the Resource Group"
  value       = azurerm_resource_group.this.id
}

output "name" {
  description = "The Name of the Resource Group"
  value       = azurerm_resource_group.this.name
}

output "location" {
  description = "The Azure Region where the Resource Group exists"
  value       = azurerm_resource_group.this.location
} 