output "load_balancer" {
  description = "The Load Balancer resource"
  value       = azurerm_lb.this
}

output "backend_address_pools" {
  description = "Map of Backend Address Pools"
  value = {
    for k, v in azurerm_lb_backend_address_pool.this : k => v
  }
}

output "backend_address_pool_addresses" {
  description = "Map of Backend Address Pool Addresses"
  value = {
    for k, v in azurerm_lb_backend_address_pool_address.this : k => v
  }
}

output "health_probes" {
  description = "Map of Health Probes"
  value = {
    for k, v in azurerm_lb_probe.this : k => v
  }
}

output "load_balancing_rules" {
  description = "Map of Load Balancing Rules"
  value = {
    for k, v in azurerm_lb_rule.this : k => v
  }
}

output "nat_rules" {
  description = "Map of NAT Rules"
  value = {
    for k, v in azurerm_lb_nat_rule.this : k => v
  }
}

output "outbound_rules" {
  description = "Map of Outbound Rules"
  value = {
    for k, v in azurerm_lb_outbound_rule.this : k => v
  }
}

output "nat_pools" {
  description = "Map of NAT Pools"
  value = {
    for k, v in azurerm_lb_nat_pool.this : k => v
  }
} 