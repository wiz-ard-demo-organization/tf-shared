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
  global_settings = var.global_settings
  resource_type   = "azurerm_resource_group"
}

# Create the Azure Resource Group
resource "azurerm_resource_group" "this" {
  name     = module.name.result
  location = var.resource_group.location

  tags = var.tags
} 