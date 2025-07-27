terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3"
    }
  }
}

module "name" {
  source          = "../_global/modules/naming"
  key             = var.key
  global_settings = var.global_settings
  settings        = var.settings
  resource_type   = "azurerm_virtual_network"
}

locals {
  resource_group = can(var.settings.resource_group.state_key) ? try(var.remote_states[var.settings.resource_group.state_key].resource_groups[var.settings.resource_group.key], null) : try(var.resource_groups[var.settings.resource_group.key], null)
}

resource "azurerm_virtual_network" "main" {
  name                = try(var.settings.name, module.name.result)
  resource_group_name = try(var.settings.resource_group_name, local.resource_group.name)
  location            = try(var.settings.location, var.global_settings.location_name)
  address_space       = try(var.settings.address_space)
  dns_servers         = try(var.settings.dns_servers, [])
}

resource "azurerm_management_lock" "main" {
  for_each   = try(var.settings.locks, {})
  name       = try(each.key, "lock")
  scope      = try(azurerm_virtual_network.main.id, null)
  lock_level = try(each.value.lock_level, "CanNotDelete")
  notes      = try(each.value.notes, "Do not Delete Lock applied")
}
