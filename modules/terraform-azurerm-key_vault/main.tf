# Module for creating and managing Azure Key Vaults with RBAC support
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

module "name" {
  source          = "../_global/modules/naming"
  key             = var.key
  settings        = var.settings
  global_settings = var.global_settings
  client_config   = var.client_config
  remote_states   = var.remote_states
  resource_type   = "azurerm_key_vault"
}

locals {
  resource_group = can(var.settings.resource_group.state_key) ? try(var.remote_states[var.settings.resource_group.state_key].resource_groups[var.settings.resource_group.key], null) : try(var.resource_groups[var.settings.resource_group.key], null)
}

# Create the Azure Key Vault with RBAC authorization enabled
resource "azurerm_key_vault" "this" {
  name                            = try(var.settings.name, module.name.result)
  resource_group_name             = try(var.settings.resource_group_name, local.resource_group.name)
  location                        = try(var.settings.location, var.global_settings.location_name)
  sku_name                        = try(var.settings.sku_name, "standard")
  tenant_id                       = try(var.settings.tenant_id, var.client_config.tenant_id)
  
  # RBAC Authorization - this is the modern approach
  enable_rbac_authorization       = try(var.settings.enable_rbac_authorization, true)
  
  # Soft delete and purge protection
  soft_delete_retention_days      = try(var.settings.soft_delete_retention_days, 7)
  purge_protection_enabled        = try(var.settings.purge_protection_enabled, false)
  
  # Access settings
  enabled_for_deployment          = try(var.settings.enabled_for_deployment, false)
  enabled_for_disk_encryption     = try(var.settings.enabled_for_disk_encryption, false)
  enabled_for_template_deployment = try(var.settings.enabled_for_template_deployment, false)
  
  # Network access
  public_network_access_enabled   = try(var.settings.public_network_access_enabled, true)
  
  # Network ACLs
  dynamic "network_acls" {
    for_each = can(var.settings.network_acls) ? [var.settings.network_acls] : []
    content {
      bypass                     = try(network_acls.value.bypass, "AzureServices")
      default_action             = try(network_acls.value.default_action, "Allow")
      ip_rules                   = try(network_acls.value.ip_rules, [])
      virtual_network_subnet_ids = try(network_acls.value.virtual_network_subnet_ids, [])
    }
  }

  # Contact information for certificate management
  dynamic "contact" {
    for_each = try(var.settings.contacts, [])
    content {
      email = contact.value.email
      name  = try(contact.value.name, null)
      phone = try(contact.value.phone, null)
    }
  }

  tags = merge(
    try(var.settings.tags, {}),
    var.tags
  )
}

# Legacy Access Policies (only if RBAC is disabled and access policies are provided)
resource "azurerm_key_vault_access_policy" "this" {
  for_each = {
    for k, v in try(var.settings.access_policies, {}) : k => v
    if try(var.settings.enable_rbac_authorization, true) == false
  }

  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = try(each.value.tenant_id, var.client_config.tenant_id)
  object_id    = each.value.object_id

  key_permissions         = try(each.value.key_permissions, [])
  secret_permissions      = try(each.value.secret_permissions, [])
  certificate_permissions = try(each.value.certificate_permissions, [])
  storage_permissions     = try(each.value.storage_permissions, [])
}
