# Module for creating and managing Azure Virtual Networks with associated subnets and network configurations
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
  resource_type   = "azurerm_virtual_network"
}

# Create the main Azure Virtual Network resource with specified address space and optional DDoS protection
resource "azurerm_virtual_network" "this" {
  name                            = module.name.result
  location                        = var.virtual_network.location
  resource_group_name             = var.virtual_network.resource_group_name
  address_space                   = var.virtual_network.address_space
  dns_servers                     = var.virtual_network.dns_servers
  edge_zone                       = var.virtual_network.edge_zone
  flow_timeout_in_minutes         = var.virtual_network.flow_timeout_in_minutes
  bgp_community                   = var.virtual_network.bgp_community

  # Configure DDoS protection plan for enhanced network security
  dynamic "ddos_protection_plan" {
    for_each = var.virtual_network.ddos_protection_plan != null ? [var.virtual_network.ddos_protection_plan] : []
    content {
      id     = ddos_protection_plan.value.id
      enable = ddos_protection_plan.value.enable
    }
  }

  # Configure encryption enforcement for network traffic
  dynamic "encryption" {
    for_each = var.virtual_network.encryption != null ? [var.virtual_network.encryption] : []
    content {
      enforcement = encryption.value.enforcement
    }
  }

  tags = var.tags
}

 