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

variable "virtual_network" {
  description = <<EOT
    virtual_network = {
      name : "(Required) The name of the virtual network. Changing this forces a new resource to be created."
      location : "(Required) The location/region where the virtual network is created. Changing this forces a new resource to be created."
      resource_group_name : "(Required) The name of the resource group in which to create the virtual network. Changing this forces a new resource to be created."
      address_space : "(Required) The address space that is used by the virtual network. You can supply more than one address space."
      dns_servers : "(Optional) List of IP addresses of DNS servers."
      edge_zone : "(Optional) Specifies the Edge Zone within the Azure Region where this Virtual Network should exist. Changing this forces a new Virtual Network to be created."
      flow_timeout_in_minutes : "(Optional) The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes."
      ddos_protection_plan : (Optional) A ddos_protection_plan block. {
        id : "(Required) The ID of DDoS Protection Plan."
        enable : "(Required) Enable/disable DDoS Protection Plan on Virtual Network."
      }
      encryption : (Optional) An encryption block. {
        enforcement : "(Required) Specifies if the encrypted Virtual Network allows VM that does not support encryption. Possible values are DropUnencrypted and AllowUnencrypted."
      }
    }
  EOT
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
  description = <<EOT
    subnets = {
      name : "(Required) The name of the subnet. Changing this forces a new resource to be created."
      address_prefixes : "(Required) The address prefixes to use for the subnet."
      private_endpoint_network_policies_enabled : "(Optional) Enable or Disable network policies for the private endpoint on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true."
      private_link_service_network_policies_enabled : "(Optional) Enable or Disable network policies for the private link service on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true."
      service_endpoints : "(Optional) The list of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage, Microsoft.Storage.Global and Microsoft.Web."
      service_endpoint_policy_ids : "(Optional) The list of IDs of Service Endpoint Policies to associate with the subnet."
      delegation : (Optional) A delegation block. {
        name : "(Required) A name for this delegation."
        service_delegation : (Required) A service_delegation block. {
          name : "(Required) The name of service to delegate to. Possible values are available from Azure CLI via: az network vnet subnet list-available-delegations."
          actions : "(Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to."
        }
      }
    }
  EOT
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
  description = "(Optional) A mapping of tags to assign to all resources created by this module."
  type        = map(string)
} 