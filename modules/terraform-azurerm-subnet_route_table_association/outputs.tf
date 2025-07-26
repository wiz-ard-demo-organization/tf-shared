# Outputs for the Azure Subnet Route Table Association module - provides association reference
output "association_id" {
  description = "The ID of the subnet route table association"
  value       = azurerm_subnet_route_table_association.this.id
} 