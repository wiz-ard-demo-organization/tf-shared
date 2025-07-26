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
  resource_type   = "azurerm_private_endpoint"
}

resource "azurerm_private_endpoint" "this" {
  name                          = try(var.private_endpoint.name, module.name.result)
  location                      = var.private_endpoint.location
  resource_group_name           = var.private_endpoint.resource_group_name
  subnet_id                     = var.private_endpoint.subnet_id
  custom_network_interface_name = var.private_endpoint.custom_network_interface_name

  private_service_connection {
    name                           = var.private_endpoint.private_service_connection.name
    private_connection_resource_id = var.private_endpoint.private_service_connection.private_connection_resource_id
    group_ids                      = var.private_endpoint.private_service_connection.group_ids
    subresource_names              = var.private_endpoint.private_service_connection.subresource_names
    is_manual_connection           = var.private_endpoint.private_service_connection.is_manual_connection
    private_connection_resource_alias = var.private_endpoint.private_service_connection.private_connection_resource_alias
    request_message                = var.private_endpoint.private_service_connection.request_message
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_endpoint.private_dns_zone_group != null ? [var.private_endpoint.private_dns_zone_group] : []
    content {
      name                 = private_dns_zone_group.value.name
      private_dns_zone_ids = private_dns_zone_group.value.private_dns_zone_ids
    }
  }

  dynamic "ip_configuration" {
    for_each = var.private_endpoint.ip_configuration != null ? var.private_endpoint.ip_configuration : []
    content {
      name               = ip_configuration.value.name
      private_ip_address = ip_configuration.value.private_ip_address
      subresource_name   = ip_configuration.value.subresource_name
      member_name        = ip_configuration.value.member_name
    }
  }

  tags = var.tags
}

# Create Private DNS Zone if specified
resource "azurerm_private_dns_zone" "this" {
  for_each = var.private_dns_zones

  name                = each.value.name
  resource_group_name = var.private_endpoint.resource_group_name

  dynamic "soa_record" {
    for_each = each.value.soa_record != null ? [each.value.soa_record] : []
    content {
      email         = soa_record.value.email
      expire_time   = soa_record.value.expire_time
      minimum_ttl   = soa_record.value.minimum_ttl
      refresh_time  = soa_record.value.refresh_time
      retry_time    = soa_record.value.retry_time
      serial_number = soa_record.value.serial_number
      ttl           = soa_record.value.ttl
      tags          = soa_record.value.tags
    }
  }

  tags = var.tags
}

# Link Private DNS Zone to Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = var.private_dns_zone_virtual_network_links

  name                  = each.value.name
  resource_group_name   = var.private_endpoint.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this[each.value.private_dns_zone_key].name
  virtual_network_id    = each.value.virtual_network_id
  registration_enabled  = each.value.registration_enabled

  tags = var.tags
}

# Create DNS A Records for the private endpoint
resource "azurerm_private_dns_a_record" "this" {
  for_each = var.private_dns_a_records

  name                = each.value.name
  zone_name           = azurerm_private_dns_zone.this[each.value.private_dns_zone_key].name
  resource_group_name = var.private_endpoint.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.records

  tags = var.tags
} 