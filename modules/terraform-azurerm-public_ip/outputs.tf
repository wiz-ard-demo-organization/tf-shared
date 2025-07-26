// Outputs for the Azure Public IP module
output "public_ip_id" {
  description = "The ID of the Public IP"
  value       = azurerm_public_ip.this.id
}

output "public_ip_address" {
  description = "The IP address value that was allocated"
  value       = azurerm_public_ip.this.ip_address
}

output "public_ip_fqdn" {
  description = "The FQDN of the Public IP"
  value       = azurerm_public_ip.this.fqdn
} 