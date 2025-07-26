output "storage_account_id" {
  description = "The ID of the Storage Account"
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "The name of the Storage Account"
  value       = azurerm_storage_account.this.name
}

output "primary_location" {
  description = "The primary location of the Storage Account"
  value       = azurerm_storage_account.this.primary_location
}

output "secondary_location" {
  description = "The secondary location of the Storage Account"
  value       = azurerm_storage_account.this.secondary_location
}

output "primary_blob_endpoint" {
  description = "The endpoint URL for blob storage in the primary location"
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "primary_queue_endpoint" {
  description = "The endpoint URL for queue storage in the primary location"
  value       = azurerm_storage_account.this.primary_queue_endpoint
}

output "primary_table_endpoint" {
  description = "The endpoint URL for table storage in the primary location"
  value       = azurerm_storage_account.this.primary_table_endpoint
}

output "primary_file_endpoint" {
  description = "The endpoint URL for file storage in the primary location"
  value       = azurerm_storage_account.this.primary_file_endpoint
}

output "primary_dfs_endpoint" {
  description = "The endpoint URL for DFS storage in the primary location"
  value       = azurerm_storage_account.this.primary_dfs_endpoint
}

output "primary_web_endpoint" {
  description = "The endpoint URL for web storage in the primary location"
  value       = azurerm_storage_account.this.primary_web_endpoint
}

output "secondary_blob_endpoint" {
  description = "The endpoint URL for blob storage in the secondary location"
  value       = azurerm_storage_account.this.secondary_blob_endpoint
}

output "secondary_queue_endpoint" {
  description = "The endpoint URL for queue storage in the secondary location"
  value       = azurerm_storage_account.this.secondary_queue_endpoint
}

output "secondary_table_endpoint" {
  description = "The endpoint URL for table storage in the secondary location"
  value       = azurerm_storage_account.this.secondary_table_endpoint
}

output "secondary_file_endpoint" {
  description = "The endpoint URL for file storage in the secondary location"
  value       = azurerm_storage_account.this.secondary_file_endpoint
}

output "secondary_dfs_endpoint" {
  description = "The endpoint URL for DFS storage in the secondary location"
  value       = azurerm_storage_account.this.secondary_dfs_endpoint
}

output "secondary_web_endpoint" {
  description = "The endpoint URL for web storage in the secondary location"
  value       = azurerm_storage_account.this.secondary_web_endpoint
}

output "primary_connection_string" {
  description = "The connection string associated with the primary location"
  value       = azurerm_storage_account.this.primary_connection_string
  sensitive   = true
}

output "secondary_connection_string" {
  description = "The connection string associated with the secondary location"
  value       = azurerm_storage_account.this.secondary_connection_string
  sensitive   = true
}

output "primary_access_key" {
  description = "The primary access key for the Storage Account"
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "The secondary access key for the Storage Account"
  value       = azurerm_storage_account.this.secondary_access_key
  sensitive   = true
}

output "primary_blob_host" {
  description = "The hostname with port if applicable for blob storage in the primary location"
  value       = azurerm_storage_account.this.primary_blob_host
}

output "secondary_blob_host" {
  description = "The hostname with port if applicable for blob storage in the secondary location"
  value       = azurerm_storage_account.this.secondary_blob_host
}

output "identity" {
  description = "An identity block with the identity configuration of the storage account"
  value       = azurerm_storage_account.this.identity
}

output "blob_properties" {
  description = "The blob properties of the Storage Account"
  value       = azurerm_storage_account.this.blob_properties
}

output "static_website" {
  description = "A static_website block with the static website configuration"
  value       = azurerm_storage_account.this.static_website
}

output "network_rules" {
  description = "A network_rules block with the network access rules configuration"
  value       = azurerm_storage_account.this.network_rules
}

output "container_ids" {
  description = "The IDs of the Storage Containers"
  value       = { for k, v in azurerm_storage_container.this : k => v.id }
}

output "container_names" {
  description = "The names of the Storage Containers"
  value       = { for k, v in azurerm_storage_container.this : k => v.name }
}

output "container_urls" {
  description = "The URLs of the Storage Containers"
  value = {
    for k, v in azurerm_storage_container.this : k => format(
      "%s/%s",
      azurerm_storage_account.this.primary_blob_endpoint,
      v.name
    )
  }
}

output "container_properties" {
  description = "Properties of all Storage Containers"
  value = {
    for k, v in azurerm_storage_container.this : k => {
      name                  = v.name
      resource_manager_id   = v.resource_manager_id
      container_access_type = v.container_access_type
      metadata              = v.metadata
      has_immutability_policy = v.has_immutability_policy
      has_legal_hold        = v.has_legal_hold
    }
  }
}

output "lifecycle_management_policy_id" {
  description = "The ID of the Storage Management Policy"
  value       = var.lifecycle_management != null ? azurerm_storage_management_policy.this[0].id : null
} 