# Module for creating and managing Azure Subnets within Virtual Networks
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
  resource_type   = "azurerm_subnet"
}

locals {
  # Get virtual network reference
  virtual_network = can(var.settings.virtual_network.state_key) ? try(var.remote_states[var.settings.virtual_network.state_key].virtual_networks[var.settings.virtual_network.key], null) : try(var.virtual_networks[var.settings.virtual_network.key], null)
}

# Create the Azure Subnet with configurable network policies and service endpoints
resource "azurerm_subnet" "this" {
  name                                          = try(var.settings.name, var.subnet.name, module.name.result)
  resource_group_name                           = try(var.settings.resource_group_name, local.virtual_network.resource_group_name, var.subnet.resource_group_name)
  virtual_network_name                          = try(var.settings.virtual_network_name, local.virtual_network.name, var.subnet.virtual_network_name)
  address_prefixes                              = try(var.settings.address_prefixes, var.subnet.address_prefixes)
  private_endpoint_network_policies_enabled     = try(var.settings.private_endpoint_network_policies_enabled, var.subnet.private_endpoint_network_policies_enabled, true)
  private_link_service_network_policies_enabled = try(var.settings.private_link_service_network_policies_enabled, var.subnet.private_link_service_network_policies_enabled, true)
  service_endpoints                             = try(var.settings.service_endpoints, var.subnet.service_endpoints, null)
  service_endpoint_policy_ids                   = try(var.settings.service_endpoint_policy_ids, var.subnet.service_endpoint_policy_ids, null)

  # Configure subnet delegation for Azure services requiring dedicated subnets
  dynamic "delegation" {
    for_each = try(var.settings.delegation, var.subnet.delegation, {})
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = try(delegation.value.service_delegation.actions, null)
      }
    }
  }
}

# Note: NSG and Route Table associations should be managed separately using the dedicated association modules 