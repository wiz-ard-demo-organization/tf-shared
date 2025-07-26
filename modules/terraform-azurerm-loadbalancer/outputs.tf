# Outputs for the Azure Load Balancer module - exposes key resource IDs and attributes for integration with other resources
output "load_balancer_id" {
  description = "The ID of the Load Balancer"
  value       = azurerm_lb.this.id
}

output "load_balancer_name" {
  description = "The name of the Load Balancer"
  value       = azurerm_lb.this.name
}

output "load_balancer_sku" {
  description = "The SKU of the Load Balancer"
  value       = azurerm_lb.this.sku
}

output "load_balancer_frontend_ip_configurations" {
  description = "The frontend IP configurations of the Load Balancer"
  value       = azurerm_lb.this.frontend_ip_configuration
}

output "load_balancer_private_ip_address" {
  description = "The first private IP address assigned to the load balancer in frontend_ip_configuration blocks"
  value       = azurerm_lb.this.private_ip_address
}

output "load_balancer_private_ip_addresses" {
  description = "The list of private IP addresses assigned to the load balancer in frontend_ip_configuration blocks"
  value       = azurerm_lb.this.private_ip_addresses
}

output "backend_address_pool_ids" {
  description = "The IDs of the Backend Address Pools"
  value       = { for k, v in azurerm_lb_backend_address_pool.this : k => v.id }
}

output "backend_address_pool_names" {
  description = "The names of the Backend Address Pools"
  value       = { for k, v in azurerm_lb_backend_address_pool.this : k => v.name }
}

output "backend_address_pool_details" {
  description = "Detailed information about all Backend Address Pools"
  value = {
    for k, v in azurerm_lb_backend_address_pool.this : k => {
      id              = v.id
      name            = v.name
      loadbalancer_id = v.loadbalancer_id
      backend_ip_configurations = v.backend_ip_configurations
      inbound_nat_rules = v.inbound_nat_rules
      load_balancing_rules = v.load_balancing_rules
      outbound_rules = v.outbound_rules
    }
  }
}

output "health_probe_ids" {
  description = "The IDs of the Health Probes"
  value       = { for k, v in azurerm_lb_probe.this : k => v.id }
}

output "health_probe_details" {
  description = "Detailed information about all Health Probes"
  value = {
    for k, v in azurerm_lb_probe.this : k => {
      id                  = v.id
      name                = v.name
      protocol            = v.protocol
      port                = v.port
      request_path        = v.request_path
      interval_in_seconds = v.interval_in_seconds
      number_of_probes    = v.number_of_probes
      load_balancer_rules = v.load_balancer_rules
    }
  }
}

output "load_balancing_rule_ids" {
  description = "The IDs of the Load Balancing Rules"
  value       = { for k, v in azurerm_lb_rule.this : k => v.id }
}

output "load_balancing_rule_details" {
  description = "Detailed information about all Load Balancing Rules"
  value = {
    for k, v in azurerm_lb_rule.this : k => {
      id                           = v.id
      name                         = v.name
      protocol                     = v.protocol
      frontend_port                = v.frontend_port
      backend_port                 = v.backend_port
      frontend_ip_configuration_id = v.frontend_ip_configuration_id
      backend_address_pool_ids     = v.backend_address_pool_ids
      probe_id                     = v.probe_id
      enable_floating_ip           = v.enable_floating_ip
      idle_timeout_in_minutes      = v.idle_timeout_in_minutes
      load_distribution            = v.load_distribution
    }
  }
}

output "nat_rule_ids" {
  description = "The IDs of the NAT Rules"
  value       = { for k, v in azurerm_lb_nat_rule.this : k => v.id }
}

output "nat_rule_details" {
  description = "Detailed information about all NAT Rules"
  value = {
    for k, v in azurerm_lb_nat_rule.this : k => {
      id                           = v.id
      name                         = v.name
      protocol                     = v.protocol
      frontend_port                = v.frontend_port
      backend_port                 = v.backend_port
      frontend_ip_configuration_id = v.frontend_ip_configuration_id
      backend_ip_configuration_id  = v.backend_ip_configuration_id
      enable_floating_ip           = v.enable_floating_ip
      idle_timeout_in_minutes      = v.idle_timeout_in_minutes
    }
  }
}

output "outbound_rule_ids" {
  description = "The IDs of the Outbound Rules"
  value       = { for k, v in azurerm_lb_outbound_rule.this : k => v.id }
}

output "outbound_rule_details" {
  description = "Detailed information about all Outbound Rules"
  value = {
    for k, v in azurerm_lb_outbound_rule.this : k => {
      id                          = v.id
      name                        = v.name
      protocol                    = v.protocol
      backend_address_pool_id     = v.backend_address_pool_id
      allocated_outbound_ports    = v.allocated_outbound_ports
      idle_timeout_in_minutes     = v.idle_timeout_in_minutes
      enable_tcp_reset            = v.enable_tcp_reset
      frontend_ip_configuration   = v.frontend_ip_configuration
    }
  }
}

output "nat_pool_ids" {
  description = "The IDs of the NAT Pools"
  value       = { for k, v in azurerm_lb_nat_pool.this : k => v.id }
}

output "nat_pool_details" {
  description = "Detailed information about all NAT Pools"
  value = {
    for k, v in azurerm_lb_nat_pool.this : k => {
      id                           = v.id
      name                         = v.name
      protocol                     = v.protocol
      frontend_port_start          = v.frontend_port_start
      frontend_port_end            = v.frontend_port_end
      backend_port                 = v.backend_port
      frontend_ip_configuration_id = v.frontend_ip_configuration_id
      idle_timeout_in_minutes      = v.idle_timeout_in_minutes
    }
  }
} 