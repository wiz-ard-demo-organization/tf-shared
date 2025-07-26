// Outputs for the Virtual Network module providing resource IDs and details.
output "virtual_network_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.this.id
}

output "virtual_network_name" {
  description = "The name of the Virtual Network"
  value       = azurerm_virtual_network.this.name
}

output "virtual_network_location" {
  description = "The location of the Virtual Network"
  value       = azurerm_virtual_network.this.location
}

output "virtual_network_address_space" {
  description = "The list of address spaces used by the Virtual Network"
  value       = azurerm_virtual_network.this.address_space
}

output "virtual_network_dns_servers" {
  description = "The list of DNS servers used by the Virtual Network"
  value       = azurerm_virtual_network.this.dns_servers
}

output "virtual_network_guid" {
  description = "The GUID of the Virtual Network"
  value       = azurerm_virtual_network.this.guid
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}

output "subnet_names" {
  description = "Map of subnet keys to their names"
  value       = { for k, v in azurerm_subnet.this : k => v.name }
}

output "subnet_address_prefixes" {
  description = "Map of subnet names to their address prefixes"
  value       = { for k, v in azurerm_subnet.this : k => v.address_prefixes }
}

output "subnet_details" {
  description = "Detailed information about all subnets"
  value = {
    for k, v in azurerm_subnet.this : k => {
      id                                            = v.id
      name                                          = v.name
      address_prefixes                              = v.address_prefixes
      private_endpoint_network_policies_enabled    = v.private_endpoint_network_policies_enabled
      private_link_service_network_policies_enabled = v.private_link_service_network_policies_enabled
      service_endpoints                             = v.service_endpoints
      service_endpoint_policy_ids                   = v.service_endpoint_policy_ids
      delegation                                    = v.delegation
    }
  }
} 