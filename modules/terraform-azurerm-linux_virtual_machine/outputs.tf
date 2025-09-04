output "linux_virtual_machine" {
  description = "The Linux Virtual Machine resource"
  value       = azurerm_linux_virtual_machine.this
}

output "network_interface" {
  description = "The Network Interface resource"
  value       = azurerm_network_interface.this
}

output "public_ip" {
  description = "The Public IP resource"
  value = try(var.settings.create_public_ip) ? azurerm_public_ip.this[0] : null
} 