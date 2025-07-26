output "route_table" {
  description = "The Route Table resource"
  value       = azurerm_route_table.this
}

output "routes" {
  description = "Map of routes in the route table"
  value = {
    for k, v in azurerm_route.this : k => v
  }
} 