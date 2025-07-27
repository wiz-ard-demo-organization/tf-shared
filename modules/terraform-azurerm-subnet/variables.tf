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

variable "virtual_networks" {
  type        = any
  default     = {}
  description = "Virtual Networks previously created and being referenced with an Instance key"
}

variable "network_security_groups" {
  type        = any
  default     = {}
  description = "Network Security Groups previously created and being referenced with an Instance key"
}

variable "route_tables" {
  type        = any
  default     = {}
  description = "Route Tables previously created and being referenced with an Instance key"
}

variable "subnet" {
  description = <<EOT
    subnet = {
      name : "(Optional) The name of the subnet. If not provided, will be generated using naming module."
      resource_group_name : "(Required) The name of the resource group in which to create the subnet."
      virtual_network_name : "(Required) The name of the parent virtual network."
      address_prefixes : "(Required) The address prefixes to use for the subnet."
      private_endpoint_network_policies_enabled : "(Optional) Enable or Disable network policies for the private endpoint on the subnet. Defaults to true."
      private_link_service_network_policies_enabled : "(Optional) Enable or Disable network policies for the private link service on the subnet. Defaults to true."
      service_endpoints : "(Optional) The list of Service endpoints to associate with the subnet."
      service_endpoint_policy_ids : "(Optional) The list of IDs of Service Endpoint Policies to associate with the subnet."
      delegation : (Optional) A delegation block. {
        name : "(Required) A name for this delegation."
        service_delegation : {
          name : "(Required) The name of service to delegate to."
          actions : "(Optional) A list of Actions which should be delegated."
        }
      }
    }
  EOT
  type = object({
    name                                          = optional(string)
    resource_group_name                           = optional(string)
    virtual_network_name                          = optional(string)
    address_prefixes                              = list(string)
    private_endpoint_network_policies_enabled     = optional(bool)
    private_link_service_network_policies_enabled = optional(bool)
    service_endpoints                             = optional(list(string))
    service_endpoint_policy_ids                   = optional(list(string))
    delegation = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(list(string))
      })
    })))
  })
  default = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
} 