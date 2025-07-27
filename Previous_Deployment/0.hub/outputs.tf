output "resource_groups" {
  value       = module.resource_groups
  description = "Resource groups created as part of level 2"
}

output "virtual_networks" {
  value       = module.virtual_networks
  description = "Virtual Networks created as part of level 2"
}

output "route_tables" {
  value       = module.route_tables
  description = "Route Tables created as part of level 2"
}

output "subnets" {
  value       = module.subnets
  description = "Subnets created as part of level 2"
}

output "network_security_groups" {
  value       = module.network_security_groups
  description = "Network security groups created as part of level 2"
}
