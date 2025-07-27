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

variable "network_security_group" {
  description = <<EOT
    network_security_group = {
      name : "(Optional) The name of the network security group. If not provided, will be generated using naming module."
      location : "(Required) The location/region where the network security group is created."
      resource_group_name : "(Required) The name of the resource group in which to create the network security group."
      security_rules : "(Optional) List of security rule objects with the following properties:
        {
          name                                       = "(Required) The name of the security rule."
          description                                = "(Optional) A description for this rule. Restricted to 140 characters."
          protocol                                   = "(Required) Network protocol this rule applies to. Possible values include Tcp, Udp, Icmp, Esp, Ah or * (which matches all)."
          source_port_range                          = "(Optional) Source Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if source_port_ranges is not specified."
          source_port_ranges                         = "(Optional) List of source ports or port ranges. This is required if source_port_range is not specified."
          destination_port_range                     = "(Optional) Destination Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if destination_port_ranges is not specified."
          destination_port_ranges                    = "(Optional) List of destination ports or port ranges. This is required if destination_port_range is not specified."
          source_address_prefix                      = "(Optional) CIDR or source IP range or * to match any IP. This is required if source_address_prefixes or source_application_security_group_ids is not specified."
          source_address_prefixes                    = "(Optional) List of source address prefixes. This is required if source_address_prefix or source_application_security_group_ids is not specified."
          source_application_security_group_ids      = "(Optional) A List of source Application Security Group IDs"
          destination_address_prefix                 = "(Optional) CIDR or destination IP range or * to match any IP. This is required if destination_address_prefixes or destination_application_security_group_ids is not specified."
          destination_address_prefixes               = "(Optional) List of destination address prefixes. This is required if destination_address_prefix or destination_application_security_group_ids is not specified."
          destination_application_security_group_ids = "(Optional) A List of destination Application Security Group IDs"
          access                                     = "(Required) Specifies whether network traffic is allowed or denied. Possible values are Allow and Deny."
          priority                                   = "(Required) Specifies the priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection."
          direction                                  = "(Required) The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are Inbound and Outbound."
        }
    }
  EOT
  type = object({
    name                = optional(string)
    location            = optional(string)
    resource_group_name = optional(string)
    security_rules = optional(list(object({
      name                                       = string
      description                                = optional(string)
      protocol                                   = string
      source_port_range                          = optional(string)
      source_port_ranges                         = optional(list(string))
      destination_port_range                     = optional(string)
      destination_port_ranges                    = optional(list(string))
      source_address_prefix                      = optional(string)
      source_address_prefixes                    = optional(list(string))
      source_application_security_group_ids      = optional(list(string))
      destination_address_prefix                 = optional(string)
      destination_address_prefixes               = optional(list(string))
      destination_application_security_group_ids = optional(list(string))
      access                                     = string
      priority                                   = number
      direction                                  = string
    })))
  })
  default = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
} 