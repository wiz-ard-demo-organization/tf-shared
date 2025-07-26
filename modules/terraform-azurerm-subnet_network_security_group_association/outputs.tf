# Outputs for the Azure Subnet Network Security Group Association module - provides association reference
output "association_id" {
  description = "The ID of the subnet NSG association"
  value       = azurerm_subnet_network_security_group_association.this.id
} 