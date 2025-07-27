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
  name                = try(var.settings.name, var.load_balancer != null ? var.load_balancer.name : null, module.name.result)
  location            = try(var.settings.location, var.global_settings.location_name, var.load_balancer != null ? var.load_balancer.location : null)
  resource_group_name = try(var.settings.resource_group_name, local.resource_group.name, var.load_balancer != null ? var.load_balancer.resource_group_name : null)
  sku                 = try(var.settings.sku, var.load_balancer != null ? var.load_balancer.sku : null)
  sku_tier            = try(var.settings.sku_tier, var.load_balancer != null ? var.load_balancer.sku_tier : null)
  edge_zone           = try(var.settings.edge_zone, var.load_balancer != null ? var.load_balancer.edge_zone : null)

  # Configure frontend IP configurations for receiving incoming traffic
  dynamic "frontend_ip_configuration" {
    for_each = try(var.settings.frontend_ip_configuration, var.load_balancer != null ? var.load_balancer.frontend_ip_configuration : null, [])
    content {
      name                          = frontend_ip_configuration.value.name
      zones                         = frontend_ip_configuration.value.zones
      subnet_id                     = frontend_ip_configuration.value.subnet_id
      private_ip_address            = frontend_ip_configuration.value.private_ip_address
      private_ip_address_allocation = frontend_ip_configuration.value.private_ip_address_allocation
      private_ip_address_version    = frontend_ip_configuration.value.private_ip_address_version
      public_ip_address_id          = frontend_ip_configuration.value.public_ip_address_id
      public_ip_prefix_id           = frontend_ip_configuration.value.public_ip_prefix_id
      gateway_load_balancer_frontend_ip_configuration_id = frontend_ip_configuration.value.gateway_load_balancer_frontend_ip_configuration_id
    }
  }

  tags = var.tags
}

# Backend Address Pools - Define groups of backend resources that will receive load-balanced traffic
resource "azurerm_lb_backend_address_pool" "this" {
  for_each = try(var.settings.backend_address_pools, var.backend_address_pools, {})

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
  for_each = try(var.settings.backend_address_pool_addresses, var.backend_address_pool_addresses, {})

  name                    = each.value.name
  backend_address_pool_id = azurerm_lb_backend_address_pool.this[each.value.backend_address_pool_key].id
  virtual_network_id      = each.value.virtual_network_id
  ip_address              = each.value.ip_address

  # Note: inbound_nat_rule_port_mapping is a computed attribute set by Azure
  # and cannot be configured manually. It will be automatically populated
  # when NAT rules are associated with this backend address pool.
}

# Health Probes - Monitor backend pool member health to ensure traffic is only sent to healthy instances
resource "azurerm_lb_probe" "this" {
  for_each = try(var.settings.health_probes, var.health_probes, {})

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
  for_each = try(var.settings.load_balancing_rules, var.load_balancing_rules, {})

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
  for_each = try(var.settings.nat_rules, var.nat_rules, {})

  name                           = each.value.name
  resource_group_name            = try(var.settings.resource_group_name, local.resource_group.name, var.load_balancer != null ? var.load_balancer.resource_group_name : null)
  loadbalancer_id                = azurerm_lb.this.id
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  idle_timeout_in_minutes        = each.value.idle_timeout_in_minutes
  enable_floating_ip             = each.value.enable_floating_ip
  enable_tcp_reset               = each.value.enable_tcp_reset
}

# Outbound Rules - Configure SNAT rules for outbound connectivity from backend pools
resource "azurerm_lb_outbound_rule" "this" {
  for_each = try(var.settings.outbound_rules, var.outbound_rules, {})

  name                     = each.value.name
  loadbalancer_id          = azurerm_lb.this.id
  protocol                 = each.value.protocol
  backend_address_pool_id  = azurerm_lb_backend_address_pool.this[each.value.backend_address_pool_key].id
  allocated_outbound_ports = each.value.allocated_outbound_ports
  idle_timeout_in_minutes  = each.value.idle_timeout_in_minutes
  enable_tcp_reset         = each.value.enable_tcp_reset

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
  for_each = try(var.settings.nat_pools, var.nat_pools, {})

  name                           = each.value.name
  resource_group_name            = try(var.settings.resource_group_name, local.resource_group.name, var.load_balancer != null ? var.load_balancer.resource_group_name : null)
  loadbalancer_id                = azurerm_lb.this.id
  protocol                       = each.value.protocol
  frontend_port_start            = each.value.frontend_port_start
  frontend_port_end              = each.value.frontend_port_end
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  idle_timeout_in_minutes        = each.value.idle_timeout_in_minutes
  floating_ip_enabled            = each.value.floating_ip_enabled
  tcp_reset_enabled              = each.value.tcp_reset_enabled
} 