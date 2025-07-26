variable "linux_virtual_machine" {
  description = <<EOT
    linux_virtual_machine = {
      name : "(Required) The name of the Linux Virtual Machine. Changing this forces a new resource to be created."
      location : "(Required) The Azure Region where the Linux Virtual Machine should exist. Changing this forces a new resource to be created."
      resource_group_name : "(Required) The name of the Resource Group in which the Linux Virtual Machine should be exist. Changing this forces a new resource to be created."
      size : "(Required) The SKU which should be used for this Virtual Machine, such as Standard_F2."
      admin_username : "(Required) The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created."
      create_public_ip : "(Optional) Whether to create a Public IP for the Virtual Machine. Defaults to false."
      disable_password_authentication : "(Optional) Should Password Authentication be disabled on this Virtual Machine? Defaults to true. Changing this forces a new resource to be created."
      admin_password : "(Optional) The Password which should be used for the local-administrator on this Virtual Machine. Required when disable_password_authentication is set to false."
      admin_ssh_key : (Optional) One or more admin_ssh_key blocks. {
        username : "(Required) The Username for which this Public SSH Key should be configured."
        public_key : "(Required) The Public Key which should be used for authentication, which needs to be at least 2048-bit and in ssh-rsa format."
      }
      os_disk : (Required) An os_disk block. {
        name : "(Optional) The name which should be used for the Internal OS Disk. Changing this forces a new resource to be created."
        caching : "(Required) The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite."
        storage_account_type : "(Required) The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS and Premium_ZRS."
        disk_size_gb : "(Optional) The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from."
        diff_disk_settings : (Optional) A diff_disk_settings block. {
          option : "(Required) Specifies the Ephemeral Disk Settings for the OS Disk. At this time the only possible value is Local. Changing this forces a new resource to be created."
          placement : "(Optional) Specifies where to store the Ephemeral Disk. Possible values are CacheDisk and ResourceDisk. Defaults to CacheDisk. Changing this forces a new resource to be created."
        }
      }
      source_image_reference : (Optional) A source_image_reference block. Either source_image_id or source_image_reference must be set. {
        publisher : "(Required) Specifies the publisher of the image used to create the virtual machines. Changing this forces a new resource to be created."
        offer : "(Required) Specifies the offer of the image used to create the virtual machines. Changing this forces a new resource to be created."
        sku : "(Required) Specifies the SKU of the image used to create the virtual machines. Changing this forces a new resource to be created."
        version : "(Required) Specifies the version of the image used to create the virtual machines. Changing this forces a new resource to be created."
      }
      source_image_id : "(Optional) The ID of the Image which this Virtual Machine should be created from. Either source_image_id or source_image_reference must be set."
      boot_diagnostics : (Optional) A boot_diagnostics block. {
        storage_account_uri : "(Optional) The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor. Passing a null value will utilize a Managed Storage Account to store Boot Diagnostics."
      }
      additional_capabilities : (Optional) An additional_capabilities block. {
        ultra_ssd_enabled : "(Optional) Should the capacity to enable Data Disks of the UltraSSD_LRS storage account type be supported on this Virtual Machine? Defaults to false."
      }
      identity : (Optional) An identity block. {
        type : "(Required) Specifies the type of Managed Service Identity that should be configured on this Linux Virtual Machine. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned."
        identity_ids : "(Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Linux Virtual Machine."
      }
      plan : (Optional) A plan block. Required when using a Marketplace image. {
        name : "(Required) Specifies the Name of the Marketplace Image this Virtual Machine should be created from. Changing this forces a new resource to be created."
        product : "(Required) Specifies the Product of the Marketplace Image this Virtual Machine should be created from. Changing this forces a new resource to be created."
        publisher : "(Required) Specifies the Publisher of the Marketplace Image this Virtual Machine should be created from. Changing this forces a new resource to be created."
      }
      custom_data : "(Optional) The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created."
      provision_vm_agent : "(Optional) Should the Azure VM Agent be provisioned on this Virtual Machine? Defaults to true. Changing this forces a new resource to be created."
      allow_extension_operations : "(Optional) Should Extension Operations be allowed on this Virtual Machine? Defaults to true."
      availability_set_id : "(Optional) Specifies the ID of the Availability Set in which the Virtual Machine should exist. Changing this forces a new resource to be created."
      proximity_placement_group_id : "(Optional) The ID of the Proximity Placement Group which the Virtual Machine should be assigned to."
      virtual_machine_scale_set_id : "(Optional) Specifies the Orchestrated Virtual Machine Scale Set that this Virtual Machine should be created within."
      zone : "(Optional) Specifies the Availability Zone in which this Linux Virtual Machine should be located. Changing this forces a new Linux Virtual Machine to be created."
      encryption_at_host_enabled : "(Optional) Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host?"
      extensions_time_budget : "(Optional) Specifies the duration allocated for all extensions to start. The time duration should be between 15 minutes and 120 minutes (inclusive) and should be specified in ISO 8601 format. Defaults to 90 minutes (PT1H30M)."
      patch_assessment_mode : "(Optional) Specifies the mode of VM Guest Patching for the Virtual Machine. Possible values are AutomaticByPlatform or ImageDefault. Defaults to ImageDefault."
      patch_mode : "(Optional) Specifies the mode of in-guest patching to this Linux Virtual Machine. Possible values are AutomaticByPlatform and ImageDefault. Defaults to ImageDefault."
      max_bid_price : "(Optional) The maximum price you're willing to pay for this Virtual Machine, in US Dollars; which must be greater than the current spot price. If this bid price falls below the current spot price the Virtual Machine will be evicted using the eviction_policy. Defaults to -1, which means that the Virtual Machine should not be evicted for price reasons."
      priority : "(Optional) Specifies the priority of this Virtual Machine. Possible values are Regular and Spot. Defaults to Regular. Changing this forces a new resource to be created."
      eviction_policy : "(Optional) Specifies what should happen when the Virtual Machine is evicted for price reasons when using a Spot instance. Possible values are Deallocate and Delete. Changing this forces a new resource to be created."
      dedicated_host_id : "(Optional) The ID of a Dedicated Host where this machine should be run on. Conflicts with dedicated_host_group_id."
      dedicated_host_group_id : "(Optional) The ID of a Dedicated Host Group that this Linux Virtual Machine should be run within. Conflicts with dedicated_host_id."
      platform_fault_domain : "(Optional) Specifies the Platform Fault Domain in which this Linux Virtual Machine should be created. Defaults to -1, which means this will be automatically assigned to a fault domain that best maintains balance across the available fault domains. Changing this forces a new Linux Virtual Machine to be created."
      computer_name : "(Optional) Specifies the Hostname which should be used for this Virtual Machine. If unspecified this defaults to the value for the name field. If the value of the name field is not a valid computer_name, then you must specify computer_name. Changing this forces a new resource to be created."
      secure_boot_enabled : "(Optional) Specifies whether secure boot should be enabled on the virtual machine. Changing this forces a new resource to be created."
      vtpm_enabled : "(Optional) Specifies whether vTPM should be enabled on the virtual machine. Changing this forces a new resource to be created."
    }
  EOT
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
  description = <<EOT
    network_interface = {
      name : "(Required) The name of the Network Interface. Changing this forces a new resource to be created."
      ip_configuration : (Required) One or more ip_configuration blocks. {
        name : "(Required) A name used for this IP Configuration."
        subnet_id : "(Required) The ID of the Subnet where this Network Interface should be located in."
        private_ip_address_allocation : "(Required) The allocation method used for the Private IP Address. Possible values are Dynamic and Static."
        private_ip_address : "(Optional) The Static IP Address which should be used. Required when private_ip_address_allocation is set to Static."
        public_ip_address_id : "(Optional) Reference to a Public IP Address to associate with this NIC."
        primary : "(Optional) Is this the Primary IP Configuration? Must be true for the first ip_configuration when multiple are specified. Defaults to true."
      }
    }
  EOT
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
  description = <<EOT
    public_ip_config = {
      name : "(Required) Specifies the name of the Public IP. Changing this forces a new Public IP to be created."
      allocation_method : "(Required) Defines the allocation method for this IP address. Possible values are Static or Dynamic."
      sku : "(Optional) The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Standard. Changing this forces a new resource to be created."
      zones : "(Optional) A collection containing the availability zone to allocate the Public IP in. Changing this forces a new resource to be created."
      domain_name_label : "(Optional) Label for the Domain Name. Will be used to make up the FQDN."
      idle_timeout_in_minutes : "(Optional) Specifies the timeout for the TCP idle connection. The value can be set between 4 and 30 minutes. Defaults to 4."
      ip_version : "(Optional) The IP Version to use, IPv6 or IPv4. Defaults to IPv4. Changing this forces a new resource to be created."
    }
  EOT
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
  description = "(Optional) The ID of the Network Security Group to associate with the Network Interface."
  type        = string
  default     = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to all resources created by this module."
  type        = map(string)
} 