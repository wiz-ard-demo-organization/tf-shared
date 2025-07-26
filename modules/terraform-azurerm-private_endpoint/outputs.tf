# Outputs for the Azure Private Endpoint module - exposes endpoint details and DNS configurations for private connectivity
output "private_endpoint" {
  description = "The Private Endpoint resource"
  value       = azurerm_private_endpoint.this
}

output "private_dns_zones" {
  description = "Map of created Private DNS Zones"
  value = {
    for k, v in azurerm_private_dns_zone.this : k => v
  }
}

output "private_dns_zone_virtual_network_links" {
  description = "Map of Private DNS Zone Virtual Network Links"
  value = {
    for k, v in azurerm_private_dns_zone_virtual_network_link.this : k => v
  }
}

output "private_dns_a_records" {
  description = "Map of Private DNS A Records"
  value = {
    for k, v in azurerm_private_dns_a_record.this : k => v
  }
} 