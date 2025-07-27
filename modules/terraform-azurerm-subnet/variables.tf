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

variable "subnet" {
  description = <<EOT
    subnet = {
      name : "(Optional) The name of the subnet. If not provided, will be generated using naming module."
      resource_group_name : "(Required) The name of the resource group in which the virtual network exists."
      virtual_network_name : "(Required) The name of the virtual network to which to attach the subnet."
      address_prefixes : "(Required) The address prefixes to use for the subnet."
      service_endpoints : "(Optional) The list of Service endpoints to associate with the subnet."
      service_endpoint_policy_ids : "(Optional) The list of IDs of Service Endpoint Policies to associate with the subnet."
      private_endpoint_network_policies : "(Optional) Enable or Disable network policies for the private endpoint on the subnet. Possible values are 'Disabled', 'Enabled', 'NetworkSecurityGroupEnabled' and 'RouteTableEnabled'. Defaults to 'Disabled'."
      private_link_service_network_policies_enabled : "(Optional) Enable or Disable network policies for the private link service on the subnet."
      default_outbound_access_enabled : "(Optional) Enable default outbound access to the internet for the subnet. Defaults to true."
      delegations : "(Optional) One or more delegation blocks for services."
    }
  EOT
  type = object({
    name                                           = optional(string)
    resource_group_name                            = string
    virtual_network_name                           = string
    address_prefixes                               = list(string)
    service_endpoints                              = optional(list(string))
    service_endpoint_policy_ids                    = optional(list(string))
    private_endpoint_network_policies             = optional(string)
    private_link_service_network_policies_enabled = optional(bool)
    default_outbound_access_enabled                = optional(bool)
    delegations = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(list(string))
      })
    })))
  })

  validation {
    condition = var.subnet.private_endpoint_network_policies == null || contains(["Disabled", "Enabled", "NetworkSecurityGroupEnabled", "RouteTableEnabled"], var.subnet.private_endpoint_network_policies)
    error_message = "private_endpoint_network_policies must be one of: 'Disabled', 'Enabled', 'NetworkSecurityGroupEnabled', 'RouteTableEnabled'."
  }
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the subnet."
  type        = map(string)
  default     = {}
} 