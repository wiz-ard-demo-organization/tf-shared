output "id" {
  value       = azurerm_virtual_network.main.id
  description = "The virtual NetworkConfiguration ID"
}

output "name" {
  value       = azurerm_virtual_network.main.name
  description = "The name of the virtual network"
}

output "location" {
  value       = azurerm_virtual_network.main.location
  description = "The location/region where the virtual network is created"
}

output "resource_group_name" {
  value       = azurerm_virtual_network.main.resource_group_name
  description = "The name of the resource group in which to create the virtual network"
}

output "address_space" {
  value       = azurerm_virtual_network.main.address_space
  description = "The address space that is used the virtual network"
}
