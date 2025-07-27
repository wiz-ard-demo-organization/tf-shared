# Module for creating and managing Azure Route Tables to control network traffic routing
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
  resource_type   = "azurerm_route_table"
}

resource "azurerm_route_table" "this" {
  name                          = module.name.result
  location                      = var.route_table.location
  resource_group_name           = var.route_table.resource_group_name
  bgp_route_propagation_enabled = !var.route_table.disable_bgp_route_propagation

  tags = var.tags
}

# Create individual routes within the route table to define traffic paths
resource "azurerm_route" "this" {
  for_each = var.routes

  name                   = each.value.name
  resource_group_name    = var.route_table.resource_group_name
  route_table_name       = azurerm_route_table.this.name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
} 