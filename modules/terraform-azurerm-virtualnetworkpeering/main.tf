terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_virtual_network_peering" "this" {
  name                         = var.peering.name
  resource_group_name          = var.peering.resource_group_name
  virtual_network_name         = var.peering.virtual_network_name
  remote_virtual_network_id    = var.peering.remote_virtual_network_id
  allow_virtual_network_access = var.peering.allow_virtual_network_access
  allow_forwarded_traffic      = var.peering.allow_forwarded_traffic
  allow_gateway_transit        = var.peering.allow_gateway_transit
  use_remote_gateways          = var.peering.use_remote_gateways
  triggers                     = var.peering.triggers
} 