variable "route_table" {
  description = "Configuration for the Route Table"
  type = object({
    name                          = string
    location                      = string
    resource_group_name           = string
    disable_bgp_route_propagation = optional(bool, false)
  })
}

variable "routes" {
  description = "Map of routes to create in the route table"
  type = map(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for route in var.routes : contains(["VirtualNetworkGateway", "VnetLocal", "Internet", "VirtualAppliance", "None"], route.next_hop_type)
    ])
    error_message = "Next hop type must be one of: 'VirtualNetworkGateway', 'VnetLocal', 'Internet', 'VirtualAppliance', or 'None'."
  }

  validation {
    condition = alltrue([
      for route in var.routes : route.next_hop_type != "VirtualAppliance" || route.next_hop_in_ip_address != null
    ])
    error_message = "next_hop_in_ip_address is required when next_hop_type is 'VirtualAppliance'."
  }

  validation {
    condition = alltrue([
      for route in var.routes : route.next_hop_type == "VirtualAppliance" || route.next_hop_in_ip_address == null
    ])
    error_message = "next_hop_in_ip_address should only be specified when next_hop_type is 'VirtualAppliance'."
  }

  validation {
    condition = alltrue([
      for route in var.routes : can(cidrhost(route.address_prefix, 0))
    ])
    error_message = "address_prefix must be a valid CIDR block (e.g., '10.0.0.0/16' or '0.0.0.0/0')."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
} 