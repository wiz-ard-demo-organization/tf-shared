# Module for creating and managing Azure Subnets
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
  resource_type   = "azurerm_subnet"
}

# Create the Azure Subnet
resource "azurerm_subnet" "this" {
  name                 = module.name.result
  resource_group_name  = var.subnet.resource_group_name
  virtual_network_name = var.subnet.virtual_network_name
  address_prefixes     = var.subnet.address_prefixes

  # Optional configurations
  service_endpoints                              = try(var.subnet.service_endpoints, null)
  service_endpoint_policy_ids                    = try(var.subnet.service_endpoint_policy_ids, null)
  private_endpoint_network_policies             = try(var.subnet.private_endpoint_network_policies, null)
  private_link_service_network_policies_enabled = try(var.subnet.private_link_service_network_policies_enabled, null)
  default_outbound_access_enabled                = try(var.subnet.default_outbound_access_enabled, null)

  # Service delegations
  dynamic "delegation" {
    for_each = var.subnet.delegations != null ? var.subnet.delegations : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
} 