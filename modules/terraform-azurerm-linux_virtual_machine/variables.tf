variable "linux_virtual_machine" {
  description = "Configuration for the Linux Virtual Machine"
  type = object({
    name                            = string
    location                        = string
    resource_group_name             = string
    size                            = string
    admin_username                  = string
    create_public_ip                = optional(bool, false)
    disable_password_authentication = optional(bool, true)
    admin_password                  = optional(string)
    
    admin_ssh_key = optional(object({
      username   = string
      public_key = string
    }))
    
    os_disk = object({
      name                 = optional(string)
      caching              = string
      storage_account_type = string
      disk_size_gb         = optional(number)
      
      diff_disk_settings = optional(object({
        option    = string
        placement = optional(string)
      }))
    })
    
    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }))
    
    source_image_id = optional(string)
    
    boot_diagnostics = optional(object({
      storage_account_uri = optional(string)
    }))
    
    additional_capabilities = optional(object({
      ultra_ssd_enabled = optional(bool, false)
    }))
    
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    
    plan = optional(object({
      name      = string
      product   = string
      publisher = string
    }))
    
    custom_data                         = optional(string)
    provision_vm_agent                  = optional(bool, true)
    allow_extension_operations          = optional(bool, true)
    availability_set_id                 = optional(string)
    proximity_placement_group_id        = optional(string)
    virtual_machine_scale_set_id        = optional(string)
    zone                                = optional(string)
    encryption_at_host_enabled          = optional(bool, false)
    extensions_time_budget              = optional(string)
    patch_assessment_mode               = optional(string)
    patch_mode                          = optional(string)
    max_bid_price                       = optional(number)
    priority                            = optional(string, "Regular")
    eviction_policy                     = optional(string)
    dedicated_host_id                   = optional(string)
    dedicated_host_group_id             = optional(string)
    platform_fault_domain              = optional(number)
    computer_name                       = optional(string)
    secure_boot_enabled                 = optional(bool)
    vtpm_enabled                        = optional(bool)
  })

  validation {
    condition = var.linux_virtual_machine.source_image_reference != null || var.linux_virtual_machine.source_image_id != null
    error_message = "Either source_image_reference or source_image_id must be specified."
  }

  validation {
    condition = var.linux_virtual_machine.disable_password_authentication == false || var.linux_virtual_machine.admin_ssh_key != null
    error_message = "When disable_password_authentication is true, admin_ssh_key must be provided."
  }
}

variable "network_interface" {
  description = "Configuration for the Network Interface"
  type = object({
    name = string
    
    ip_configuration = list(object({
      name                          = string
      subnet_id                     = string
      private_ip_address_allocation = string
      private_ip_address            = optional(string)
      public_ip_address_id          = optional(string)
      primary                       = optional(bool, true)
    }))
  })

  validation {
    condition = length(var.network_interface.ip_configuration) > 0
    error_message = "At least one IP configuration must be specified."
  }
}

variable "public_ip_config" {
  description = "Configuration for the Public IP (when create_public_ip is true)"
  type = object({
    name                    = string
    allocation_method       = string
    sku                     = optional(string, "Standard")
    zones                   = optional(list(string))
    domain_name_label       = optional(string)
    idle_timeout_in_minutes = optional(number, 4)
    ip_version              = optional(string, "IPv4")
  })
  default = {
    name              = "default-pip"
    allocation_method = "Static"
    sku              = "Standard"
  }
}

variable "network_security_group_id" {
  description = "ID of the Network Security Group to associate with the Network Interface"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
} 