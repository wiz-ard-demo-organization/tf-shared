# Module for creating and configuring Azure Load Balancer resources with support for multiple frontend IPs, backend pools, health probes, and various load balancing rules
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
  resource_type   = "azurerm_lb"
}

locals {
  resource_group = can(var.settings.resource_group.state_key) ? try(var.remote_states[var.settings.resource_group.state_key].resource_groups[var.settings.resource_group.key], null) : try(var.resource_groups[var.settings.resource_group.key], null)
}

# Create the main Azure Load Balancer resource with specified SKU and frontend IP configurations
resource "azurerm_lb" "this" {
  name                = try(var.settings.name, module.name.result)
  location            = try(var.settings.location, var.global_settings.location_name)
  resource_group_name = try(var.settings.resource_group_name, local.resource_group.name)
  sku                 = try(var.settings.sku, null)
  sku_tier            = try(var.settings.sku_tier, null)
  edge_zone           = try(var.settings.edge_zone, null)

  # Configure frontend IP configurations for receiving incoming traffic
  dynamic "frontend_ip_configuration" {
    for_each = try(var.settings.frontend_ip_configuration, [])
    content {
      name                          = frontend_ip_configuration.value.name
      zones                         = try(frontend_ip_configuration.value.zones, null)
      subnet_id                     = try(frontend_ip_configuration.value.subnet_id, null)
      private_ip_address            = try(frontend_ip_configuration.value.private_ip_address, null)
      private_ip_address_allocation = try(frontend_ip_configuration.value.private_ip_address_allocation, null)
      private_ip_address_version    = try(frontend_ip_configuration.value.private_ip_address_version, null)
      public_ip_address_id          = try(
        frontend_ip_configuration.value.public_ip_address_id != null && can(var.public_ips[frontend_ip_configuration.value.public_ip_address_id]) ? var.public_ips[frontend_ip_configuration.value.public_ip_address_id].id : frontend_ip_configuration.value.public_ip_address_id,
        null
      )
      public_ip_prefix_id           = try(frontend_ip_configuration.value.public_ip_prefix_id, null)
      gateway_load_balancer_frontend_ip_configuration_id = try(frontend_ip_configuration.value.gateway_load_balancer_frontend_ip_configuration_id, null)
    }
  }

  tags = var.tags
}

# Backend Address Pools - Define groups of backend resources that will receive load-balanced traffic
resource "azurerm_lb_backend_address_pool" "this" {
  for_each = try(var.settings.backend_address_pools, {})

  name            = each.value.name
  loadbalancer_id = azurerm_lb.this.id

  # Optional tunnel interface configuration for Gateway Load Balancer scenarios
  dynamic "tunnel_interface" {
    for_each = try(each.value.tunnel_interface, [])
    content {
      identifier = tunnel_interface.value.identifier
      type       = tunnel_interface.value.type
      protocol   = tunnel_interface.value.protocol
      port       = tunnel_interface.value.port
    }
  }
}

# Backend Address Pool Addresses - Specify individual backend IP addresses within the backend pools
resource "azurerm_lb_backend_address_pool_address" "this" {
  for_each = try(var.settings.backend_address_pool_addresses, {})

  name                    = each.value.name
  backend_address_pool_id = azurerm_lb_backend_address_pool.this[each.value.backend_address_pool_key].id
  virtual_network_id      = each.value.virtual_network_id
  ip_address              = each.value.ip_address
}

# Health Probes - Monitor backend pool member health to ensure traffic is only sent to healthy instances
resource "azurerm_lb_probe" "this" {
  for_each = try(var.settings.health_probes, {})

  name                = each.value.name
  loadbalancer_id     = azurerm_lb.this.id
  protocol            = each.value.protocol
  port                = each.value.port
  probe_threshold     = try(each.value.probe_threshold, null)
  request_path        = try(each.value.request_path, null)
  interval_in_seconds = try(each.value.interval_in_seconds, null)
  number_of_probes    = try(each.value.number_of_probes, null)
}

# Load Balancing Rules - Define how traffic is distributed from frontend to backend pools
resource "azurerm_lb_rule" "this" {
  for_each = try(var.settings.load_balancing_rules, {})

  name                           = each.value.name
  loadbalancer_id                = azurerm_lb.this.id
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  backend_address_pool_ids       = [for pool_key in each.value.backend_address_pool_keys : azurerm_lb_backend_address_pool.this[pool_key].id]
  probe_id                       = each.value.probe_key != null ? azurerm_lb_probe.this[each.value.probe_key].id : null
  enable_floating_ip             = try(each.value.enable_floating_ip, null)
  idle_timeout_in_minutes        = try(each.value.idle_timeout_in_minutes, null)
  load_distribution              = try(each.value.load_distribution, null)
  disable_outbound_snat          = try(each.value.disable_outbound_snat, null)
  enable_tcp_reset               = try(each.value.enable_tcp_reset, null)
}

# NAT Rules - Configure inbound NAT rules for direct connectivity to specific backend instances
resource "azurerm_lb_nat_rule" "this" {
  for_each = try(var.settings.nat_rules, {})

  name                           = each.value.name
  resource_group_name            = try(var.settings.resource_group_name, local.resource_group.name)
  loadbalancer_id                = azurerm_lb.this.id
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  idle_timeout_in_minutes        = try(each.value.idle_timeout_in_minutes, null)
  enable_floating_ip             = try(each.value.enable_floating_ip, null)
  enable_tcp_reset               = try(each.value.enable_tcp_reset, null)
}

# Outbound Rules - Configure SNAT rules for outbound connectivity from backend pools
resource "azurerm_lb_outbound_rule" "this" {
  for_each = try(var.settings.outbound_rules, {})

  name                     = each.value.name
  loadbalancer_id          = azurerm_lb.this.id
  protocol                 = each.value.protocol
  backend_address_pool_id  = azurerm_lb_backend_address_pool.this[each.value.backend_address_pool_key].id
  allocated_outbound_ports = try(each.value.allocated_outbound_ports, null)
  idle_timeout_in_minutes  = try(each.value.idle_timeout_in_minutes, null)
  enable_tcp_reset         = try(each.value.enable_tcp_reset, null)

  # Specify which frontend IPs to use for outbound connections
  dynamic "frontend_ip_configuration" {
    for_each = each.value.frontend_ip_configuration_names
    content {
      name = frontend_ip_configuration.value
    }
  }
}

# NAT Pool - Configure NAT pools for Virtual Machine Scale Sets to enable inbound connectivity
resource "azurerm_lb_nat_pool" "this" {
  for_each = try(var.settings.nat_pools, {})

  name                           = each.value.name
  resource_group_name            = try(var.settings.resource_group_name, local.resource_group.name)
  loadbalancer_id                = azurerm_lb.this.id
  protocol                       = each.value.protocol
  frontend_port_start            = each.value.frontend_port_start
  frontend_port_end              = each.value.frontend_port_end
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  idle_timeout_in_minutes        = try(each.value.idle_timeout_in_minutes, null)
  floating_ip_enabled            = try(each.value.floating_ip_enabled, null)
  tcp_reset_enabled              = try(each.value.tcp_reset_enabled, null)
} 