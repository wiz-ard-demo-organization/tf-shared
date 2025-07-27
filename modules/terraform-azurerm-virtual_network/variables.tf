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
      bgp_community : "(Optional) The BGP community attribute in format <as-number>:<community-value>. The as-number segment is the Microsoft ASN, which is always 12076 for now."
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
    name                    = optional(string)
    location                = string
    resource_group_name     = string
    address_space           = list(string)
    dns_servers             = optional(list(string))
    edge_zone               = optional(string)
    flow_timeout_in_minutes = optional(number)
    bgp_community           = optional(string)

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

  validation {
    condition = var.virtual_network.flow_timeout_in_minutes == null || (var.virtual_network.flow_timeout_in_minutes >= 4 && var.virtual_network.flow_timeout_in_minutes <= 30)
    error_message = "flow_timeout_in_minutes must be between 4 and 30 minutes."
  }
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to all resources created by this module."
  type        = map(string)
} 