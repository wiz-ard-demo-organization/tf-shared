// Outputs for the Azure Public IP module
output "public_ip" {
  description = "The Public IP resource"
  value       = azurerm_public_ip.this
} 