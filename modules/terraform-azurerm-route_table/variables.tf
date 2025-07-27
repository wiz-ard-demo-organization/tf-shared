variable "key" {
  type        = string
  default     = null
  description = "Identifies the specific resource instance being deployed"
}

variable "settings" {
  type        = any
  default     = {}
  description = "Provides the configuration values for the specific resources being deployed"
}

variable "global_settings" {
  type        = any
  default     = {}
  description = "Global configurations for the Azure Landing Zone"
}

variable "client_config" {
  type        = any
  default     = null
  description = "Data source to access the configurations of the Azurerm provider"
}

variable "remote_states" {
  type        = any
  default     = {}
  description = "Outputs from the previous deployments that are stored in additional Terraform State Files"
}

variable "resource_groups" {
  type        = any
  default     = {}
  description = "Resource Groups previously created and being referenced with an Instance key"
}

variable "route_table" {
  description = <<EOT
    route_table = {
      name : "(Optional) The name of the route table. If not provided, will be generated using naming module."
      location : "(Required) The Azure Region where the Route Table should exist."
      resource_group_name : "(Required) The name of the Resource Group where the Route Table should exist."
      disable_bgp_route_propagation : "(Optional) Boolean flag which controls propagation of routes learned by BGP on that route table. True means disable."
      routes : "(Optional) List of route objects. Each route object supports:
        {
          name : "(Required) The name of the route."
          address_prefix : "(Required) The destination to which the route applies. Can be CIDR (such as 10.1.0.0/16) or Azure Service Tag (such as ApiManagement, AzureBackup or AzureMonitor) format."
          next_hop_type : "(Required) The type of Azure hop the packet should be sent to. Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None."
          next_hop_in_ip_address : "(Optional) Contains the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance."
        }
    }
  EOT
  type = object({
    name                          = optional(string)
    location                      = optional(string)
    resource_group_name           = optional(string)
    disable_bgp_route_propagation = optional(bool)
    routes = optional(list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    })))
  })
  default = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
} 