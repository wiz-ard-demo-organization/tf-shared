// Outputs for the Virtual Network module providing resource IDs and details.
output "virtual_network" {
  description = "The Virtual Network resource"
  value       = azurerm_virtual_network.this
}

output "id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.this.id
}

output "name" {
  description = "The name of the Virtual Network"
  value       = azurerm_virtual_network.this.name
}

output "guid" {
  description = "The GUID of the Virtual Network"
  value       = azurerm_virtual_network.this.guid
}

output "location" {
  description = "The Azure Region where the Virtual Network exists"
  value       = azurerm_virtual_network.this.location
}

output "address_space" {
  description = "The address space of the Virtual Network"
  value       = azurerm_virtual_network.this.address_space
}

 