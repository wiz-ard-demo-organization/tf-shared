output "key_vault" {
  description = "The complete Key Vault resource object"
  value       = azurerm_key_vault.this
}

output "id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.this.id
}

output "name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.this.name
}

output "vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.this.vault_uri
}

output "resource_group_name" {
  description = "The resource group name of the Key Vault"
  value       = azurerm_key_vault.this.resource_group_name
}

output "location" {
  description = "The location of the Key Vault"
  value       = azurerm_key_vault.this.location
}

output "tenant_id" {
  description = "The tenant ID of the Key Vault"
  value       = azurerm_key_vault.this.tenant_id
}

output "enable_rbac_authorization" {
  description = "Whether RBAC authorization is enabled"
  value       = azurerm_key_vault.this.enable_rbac_authorization
} 