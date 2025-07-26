// Module to create an Azure Public IP resource with customizable settings.
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
  resource_type   = "azurerm_public_ip"
}

// Create an Azure Public IP resource with the provided configuration.
resource "azurerm_public_ip" "this" {
  name                    = try(var.public_ip.name, module.name.result)
  location                = var.public_ip.location
  resource_group_name     = var.public_ip.resource_group_name
  allocation_method       = var.public_ip.allocation_method
  sku                     = var.public_ip.sku
  sku_tier                = var.public_ip.sku_tier
  zones                   = var.public_ip.zones
  domain_name_label       = var.public_ip.domain_name_label
  idle_timeout_in_minutes = var.public_ip.idle_timeout_in_minutes
  ip_version              = var.public_ip.ip_version
  ip_tags                 = var.public_ip.ip_tags
  public_ip_prefix_id     = var.public_ip.public_ip_prefix_id
  reverse_fqdn            = var.public_ip.reverse_fqdn
  edge_zone               = var.public_ip.edge_zone
  ddos_protection_mode    = var.public_ip.ddos_protection_mode
  ddos_protection_plan_id = var.public_ip.ddos_protection_plan_id

  tags = var.tags
} 