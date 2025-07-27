terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

provider "azurerm" {
  features {}
  alias           = "devops"
  subscription_id = var.global_settings.subscription_ids.devops
}

provider "azurerm" {
  features {}
  alias           = "connectivity"
  subscription_id = var.global_settings.subscription_ids.connectivity
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azuread_client_config" "current" {}

module "resource_groups" {
  source          = "./modules/terraform-azurerm-platform-infra/modules/resource_group"
  for_each        = var.resource_groups
  key             = each.key
  settings        = each.value
  global_settings = var.global_settings
  client_config   = data.azurerm_client_config.current
}

module "virtual_networks" {
  source          = "./modules/terraform-azurerm-platform-infra/modules/virtual_network"
  for_each        = var.virtual_networks
  key             = each.key
  settings        = each.value
  global_settings = var.global_settings
  client_config   = data.azurerm_client_config.current
  resource_groups = module.resource_groups
}

module "network_security_groups" {
  source          = "./modules/terraform-azurerm-platform-infra/modules/network_security_group"
  for_each        = var.network_security_groups
  key             = each.key
  settings        = each.value
  global_settings = var.global_settings
  client_config   = data.azurerm_client_config.current
  resource_groups = module.resource_groups
}

module "route_tables" {
  source          = "./modules/terraform-azurerm-platform-infra/modules/route_table"
  for_each        = var.route_tables
  key             = each.key
  settings        = each.value
  global_settings = var.global_settings
  client_config   = data.azurerm_client_config.current
  resource_groups = module.resource_groups
}

module "subnets" {
  source                  = "./modules/terraform-azurerm-platform-infra/modules/subnet"
  for_each                = var.subnets
  key                     = each.key
  settings                = each.value
  global_settings         = var.global_settings
  client_config           = data.azurerm_client_config.current
  virtual_networks        = module.virtual_networks
  network_security_groups = module.network_security_groups
  route_tables            = module.route_tables
}
