# Module for creating and managing Azure Route Tables with custom routes for network traffic control
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
  resource_type   = "azurerm_route_table"
}

locals {
  resource_group = can(var.settings.resource_group.state_key) ? try(var.remote_states[var.settings.resource_group.state_key].resource_groups[var.settings.resource_group.key], null) : try(var.resource_groups[var.settings.resource_group.key], null)
  # Handle both settings.routes and route_table.routes formats
  routes = try(var.settings.routes, var.route_table.routes, {})
}

# Create the Azure Route Table
resource "azurerm_route_table" "this" {
  name                          = try(var.settings.name, var.route_table.name, module.name.result)
  resource_group_name           = try(var.settings.resource_group_name, local.resource_group.name, var.route_table.resource_group_name)
  location                      = try(var.settings.location, var.global_settings.location_name, var.route_table.location)
  bgp_route_propagation_enabled = try(!var.settings.disable_bgp_route_propagation, var.route_table.disable_bgp_route_propagation != null ? !var.route_table.disable_bgp_route_propagation : true, true)

  tags = var.tags
}

# Create individual routes in the route table
resource "azurerm_route" "this" {
  for_each = local.routes

  name                   = each.value.name
  resource_group_name    = azurerm_route_table.this.resource_group_name
  route_table_name       = azurerm_route_table.this.name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = try(each.value.next_hop_in_ip_address, null)
} 