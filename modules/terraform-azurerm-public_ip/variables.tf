variable "public_ip" {
  description = "Configuration for the Azure Public IP"
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
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
} 