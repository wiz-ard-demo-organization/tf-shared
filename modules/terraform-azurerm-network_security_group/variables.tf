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

variable "network_security_group" {
  description = <<EOT
    network_security_group = {
      name : "(Optional) The name of the Network Security Group. If not provided, will be generated using naming module."
      location : "(Required) The Azure Region where the Network Security Group should exist."
      resource_group_name : "(Required) The name of the resource group in which to create the Network Security Group."
      security_rules : "(Optional) List of security rules for the Network Security Group."
    }
  EOT
  type = object({
    name                = optional(string)
    location            = string
    resource_group_name = string
    security_rules = optional(list(object({
      name                                       = string
      priority                                   = number
      direction                                  = string
      access                                     = string
      protocol                                   = string
      source_port_range                          = string
      destination_port_range                     = string
      source_address_prefix                      = string
      destination_address_prefix                 = string
      source_port_ranges                         = optional(list(string))
      destination_port_ranges                    = optional(list(string))
      source_address_prefixes                    = optional(list(string))
      destination_address_prefixes               = optional(list(string))
      source_application_security_group_ids      = optional(list(string))
      destination_application_security_group_ids = optional(list(string))
      description                                = optional(string)
    })))
  })
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the Network Security Group."
  type        = map(string)
  default     = {}
} 