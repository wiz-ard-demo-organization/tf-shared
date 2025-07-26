// Outputs for the Virtual Network module providing resource IDs and details.
output "virtual_network" {
  description = "The Virtual Network resource"
  value       = azurerm_virtual_network.this
}

output "subnets" {
  description = "Map of subnets"
  value = {
    for k, v in azurerm_subnet.this : k => v
  }
} 