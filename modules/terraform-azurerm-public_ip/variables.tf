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
    name                    = optional(string)
    location                = optional(string)
    resource_group_name     = optional(string)
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
  default = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
} 