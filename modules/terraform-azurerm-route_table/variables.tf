variable "key" {
  type        = string
  default     = null
  description = "Identifies the specific resource instance being deployed"
}

variable "global_settings" {
  type        = any
  default     = {}
  description = "Global configurations for the Azure Landing Zone"
}

variable "route_table" {
  description = <<EOT
    route_table = {
      name : "(Required) The name of the route table. Changing this forces a new resource to be created."
      location : "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
      resource_group_name : "(Required) The name of the resource group in which to create the route table. Changing this forces a new resource to be created."
      disable_bgp_route_propagation : "(Optional) Boolean flag which controls propagation of routes learned by BGP on that route table. True means disable. Defaults to false. Note: This parameter is converted to bgp_route_propagation_enabled (inverted) to use the current AzureRM provider parameter."
    }
  EOT
  type = object({
    name                          = optional(string)
    location                      = string
    resource_group_name           = string
    disable_bgp_route_propagation = optional(bool, false)
  })
}

variable "routes" {
  description = <<EOT
    routes = {
      name : "(Required) The name of the route. Changing this forces a new resource to be created."
      address_prefix : "(Required) The destination to which the route applies. Can be CIDR (such as 10.1.0.0/16) or Azure Service Tag (such as ApiManagement, AzureBackup or AzureBotService)."
      next_hop_type : "(Required) The type of Azure hop the packet should be sent to. Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None."
      next_hop_in_ip_address : "(Optional) Contains the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance."
    }
  EOT
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
  description = "(Optional) A mapping of tags to assign to all resources created by this module."
  type        = map(string)
} 