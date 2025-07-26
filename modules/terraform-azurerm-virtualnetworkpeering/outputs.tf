# Outputs for the Azure Virtual Network Peering module - exposes peering details for network topology reference
output "peering_id" {
  description = "The ID of the virtual network peering"
  value       = azurerm_virtual_network_peering.this.id
}

output "peering_name" {
  description = "The name of the virtual network peering"
  value       = azurerm_virtual_network_peering.this.name
}

output "resource_guid" {
  description = "The resource GUID of the virtual network peering"
  value       = azurerm_virtual_network_peering.this.resource_guid
} 