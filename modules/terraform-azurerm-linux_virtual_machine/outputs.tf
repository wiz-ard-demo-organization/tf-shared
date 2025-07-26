# Outputs for the Azure Linux Virtual Machine module - exposes VM IDs, network details, and public/private IP addresses for integration
output "virtual_machine_id" {
  description = "The ID of the Linux Virtual Machine"
  value       = azurerm_linux_virtual_machine.this.id
}

output "virtual_machine_name" {
  description = "The name of the Linux Virtual Machine"
  value       = azurerm_linux_virtual_machine.this.name
}

output "virtual_machine_private_ip_address" {
  description = "The primary private IP address of the Linux Virtual Machine"
  value       = azurerm_linux_virtual_machine.this.private_ip_address
}

output "virtual_machine_private_ip_addresses" {
  description = "The list of private IP addresses of the Linux Virtual Machine"
  value       = azurerm_linux_virtual_machine.this.private_ip_addresses
}

output "virtual_machine_public_ip_address" {
  description = "The primary public IP address of the Linux Virtual Machine"
  value       = azurerm_linux_virtual_machine.this.public_ip_address
}

output "virtual_machine_public_ip_addresses" {
  description = "The list of public IP addresses of the Linux Virtual Machine"
  value       = azurerm_linux_virtual_machine.this.public_ip_addresses
}

output "virtual_machine_identity" {
  description = "The identity block of the Linux Virtual Machine"
  value       = azurerm_linux_virtual_machine.this.identity
}

output "public_ip_id" {
  description = "The ID of the Public IP"
  value       = var.linux_virtual_machine.create_public_ip ? azurerm_public_ip.this[0].id : null
}

output "public_ip_address" {
  description = "The IP address value that was allocated for the Public IP"
  value       = var.linux_virtual_machine.create_public_ip ? azurerm_public_ip.this[0].ip_address : null
}

output "public_ip_fqdn" {
  description = "The FQDN associated with the Public IP"
  value       = var.linux_virtual_machine.create_public_ip ? azurerm_public_ip.this[0].fqdn : null
}

output "network_interface_id" {
  description = "The ID of the Network Interface"
  value       = azurerm_network_interface.this.id
}

output "network_interface_private_ip_address" {
  description = "The first private IP address of the network interface"
  value       = azurerm_network_interface.this.private_ip_address
}

output "network_interface_private_ip_addresses" {
  description = "The private IP addresses of the network interface"
  value       = azurerm_network_interface.this.private_ip_addresses
} 