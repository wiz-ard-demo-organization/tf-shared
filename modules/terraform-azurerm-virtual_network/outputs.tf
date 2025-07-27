// Outputs for the Virtual Network module providing resource IDs and details.
output "virtual_network" {
  description = "The Virtual Network resource"
  value       = azurerm_virtual_network.this
}

output "id" {
  value       = azurerm_virtual_network.this.id
  description = "The virtual network ID"
}

output "name" {
  value       = azurerm_virtual_network.this.name
  description = "The name of the virtual network"
}

output "location" {
  value       = azurerm_virtual_network.this.location
  description = "The location/region where the virtual network is created"
}

output "resource_group_name" {
  value       = azurerm_virtual_network.this.resource_group_name
  description = "The name of the resource group in which the virtual network is created"
}

output "address_space" {
  value       = azurerm_virtual_network.this.address_space
  description = "The address space that is used by the virtual network"
}

output "guid" {
  value       = azurerm_virtual_network.this.guid
  description = "The GUID of the virtual network"
}

 