output "network_security_group" {
  description = "The complete Network Security Group object"
  value       = azurerm_network_security_group.this
}

output "id" {
  description = "The ID of the Network Security Group"
  value       = azurerm_network_security_group.this.id
}

output "name" {
  description = "The Name of the Network Security Group"
  value       = azurerm_network_security_group.this.name
}

output "location" {
  description = "The Azure Region where the Network Security Group exists"
  value       = azurerm_network_security_group.this.location
} 