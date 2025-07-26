variable "peering" {
  description = "Configuration for the virtual network peering"
  type = object({
    name                         = string
    resource_group_name          = string
    virtual_network_name         = string
    remote_virtual_network_id    = string
    allow_virtual_network_access = optional(bool)
    allow_forwarded_traffic      = optional(bool)
    allow_gateway_transit        = optional(bool)
    use_remote_gateways          = optional(bool)
    triggers                     = optional(map(string))
  })

  validation {
    condition = !(try(var.peering.allow_gateway_transit, false) && try(var.peering.use_remote_gateways, false))
    error_message = "allow_gateway_transit and use_remote_gateways cannot both be true for the same peering."
  }
} 