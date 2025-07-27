# Module for creating and managing Azure Resource Groups
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
  resource_type   = "azurerm_resource_group"
}

# Create the Azure Resource Group
resource "azurerm_resource_group" "this" {
  name     = try(var.settings.name, var.resource_group.name, module.name.result)
  location = try(var.settings.location, var.global_settings.location_name, var.resource_group.location)

  tags = var.tags
} 