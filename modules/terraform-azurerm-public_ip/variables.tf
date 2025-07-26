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

variable "public_ip" {
  description = <<EOT
public_ip = {
  name : "(Required) Specifies the name of the Public IP resource. Changing this forces a new resource to be created."
  location : "(Required) Specifies the Azure region where the resource exists. Changing this forces a new resource to be created."
  resource_group_name : "(Required) The name of the resource group in which to create the Public IP. Changing this forces a new resource to be created."
  allocation_method : "(Required) The allocation method for the Public IP. Must be either Static or Dynamic. Changing this forces a new resource to be created."
  sku : "(Optional) SKU of the Public IP. Possible values are Basic and Standard."
  sku_tier : "(Optional) SKU tier of the Public IP. Possible values are Regional and Global."
  zones : "(Optional) A list of Availability Zones into which to provision the Public IP. Changing this forces a new resource to be created."
  domain_name_label : "(Optional) A domain name label. Changing this forces a new resource to be created."
  idle_timeout_in_minutes : "(Optional) The timeout for idle connections in minutes."
  ip_version : "(Optional) The IP version. Possible values are IPv4 and IPv6."
  ip_tags : "(Optional) A mapping of IP tags."
  public_ip_prefix_id : "(Optional) The ID of the Public IP Prefix to associate."
  reverse_fqdn : "(Optional) The reverse FQDN of the Public IP."
  edge_zone : "(Optional) Edge zone in which to create the resource."
  ddos_protection_mode : "(Optional) The DDOS protection mode. Possible values are Off, Alert, Deny."
  ddos_protection_plan_id : "(Optional) The ID of the DDOS protection plan to apply."
}
EOT
  type = object({
    name                    = string
    location                = string
    resource_group_name     = string
    allocation_method       = string
    sku                     = optional(string)
    sku_tier                = optional(string)
    zones                   = optional(list(string))
    domain_name_label       = optional(string)
    idle_timeout_in_minutes = optional(number)
    ip_version              = optional(string)
    ip_tags                 = optional(map(string))
    public_ip_prefix_id     = optional(string)
    reverse_fqdn            = optional(string)
    edge_zone               = optional(string)
    ddos_protection_mode    = optional(string)
    ddos_protection_plan_id = optional(string)
  })

  validation {
    condition = contains(["Static", "Dynamic"], var.public_ip.allocation_method)
    error_message = "Allocation method must be either 'Static' or 'Dynamic'."
  }

  validation {
    condition = var.public_ip.sku == null || contains(["Basic", "Standard"], var.public_ip.sku)
    error_message = "SKU must be either 'Basic' or 'Standard'."
  }

  validation {
    condition = var.public_ip.sku_tier == null || contains(["Regional", "Global"], var.public_ip.sku_tier)
    error_message = "SKU tier must be either 'Regional' or 'Global'."
  }

  validation {
    condition = var.public_ip.ip_version == null || contains(["IPv4", "IPv6"], var.public_ip.ip_version)
    error_message = "IP version must be either 'IPv4' or 'IPv6'."
  }
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource"
  type        = map(string)
} 