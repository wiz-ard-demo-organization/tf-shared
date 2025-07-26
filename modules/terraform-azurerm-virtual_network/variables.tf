variable "virtual_network" {
  description = "Configuration for the Azure Virtual Network"
  type = object({
    name                    = string
    location                = string
    resource_group_name     = string
    address_space           = list(string)
    dns_servers             = optional(list(string))
    edge_zone               = optional(string)
    flow_timeout_in_minutes = optional(number)

    ddos_protection_plan = optional(object({
      id     = string
      enable = bool
    }))

    encryption = optional(object({
      enforcement = string
    }))
  })

  validation {
    condition = length(var.virtual_network.address_space) > 0
    error_message = "At least one address space must be specified for the virtual network."
  }

  validation {
    condition = var.virtual_network.encryption == null || contains(["AllowUnencrypted", "DropUnencrypted"], var.virtual_network.encryption.enforcement)
    error_message = "Encryption enforcement must be either 'AllowUnencrypted' or 'DropUnencrypted'."
  }
}

variable "subnets" {
  description = "Map of subnets to create within the virtual network"
  type = map(object({
    name                                          = string
    address_prefixes                              = list(string)
    private_endpoint_network_policies_enabled    = optional(bool)
    private_link_service_network_policies_enabled = optional(bool)
    service_endpoints                             = optional(list(string))
    service_endpoint_policy_ids                   = optional(list(string))

    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(list(string))
      })
    }))
  }))
  default = {}

  validation {
    condition = alltrue([
      for subnet in var.subnets : length(subnet.address_prefixes) > 0
    ])
    error_message = "Each subnet must have at least one address prefix."
  }

  validation {
    condition = alltrue([
      for subnet in var.subnets : alltrue([
        for endpoint in coalesce(subnet.service_endpoints, []) : contains([
          "Microsoft.AzureActiveDirectory",
          "Microsoft.AzureCosmosDB", 
          "Microsoft.ContainerRegistry",
          "Microsoft.EventHub",
          "Microsoft.KeyVault",
          "Microsoft.ServiceBus", 
          "Microsoft.Sql",
          "Microsoft.Storage",
          "Microsoft.Storage.Global",
          "Microsoft.Web"
        ], endpoint)
      ])
    ])
    error_message = "Invalid service endpoint specified. Must be a valid Microsoft service endpoint."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
} 