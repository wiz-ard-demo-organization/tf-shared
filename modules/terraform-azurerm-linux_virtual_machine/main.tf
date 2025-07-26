terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_public_ip" "this" {
  count = var.linux_virtual_machine.create_public_ip ? 1 : 0

  name                = var.public_ip_config.name
  location            = var.linux_virtual_machine.location
  resource_group_name = var.linux_virtual_machine.resource_group_name
  allocation_method   = var.public_ip_config.allocation_method
  sku                 = var.public_ip_config.sku
  zones               = var.public_ip_config.zones
  domain_name_label   = var.public_ip_config.domain_name_label
  idle_timeout_in_minutes = var.public_ip_config.idle_timeout_in_minutes
  ip_version          = var.public_ip_config.ip_version

  tags = var.tags
}

resource "azurerm_network_interface" "this" {
  name                = var.network_interface.name
  location            = var.linux_virtual_machine.location
  resource_group_name = var.linux_virtual_machine.resource_group_name

  dynamic "ip_configuration" {
    for_each = var.network_interface.ip_configuration
    content {
      name                          = ip_configuration.value.name
      subnet_id                     = ip_configuration.value.subnet_id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      private_ip_address            = ip_configuration.value.private_ip_address
      public_ip_address_id          = var.linux_virtual_machine.create_public_ip ? azurerm_public_ip.this[0].id : ip_configuration.value.public_ip_address_id
      primary                       = ip_configuration.value.primary
    }
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "this" {
  count = var.network_security_group_id != null ? 1 : 0

  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = var.network_security_group_id
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = var.linux_virtual_machine.name
  location            = var.linux_virtual_machine.location
  resource_group_name = var.linux_virtual_machine.resource_group_name
  size                = var.linux_virtual_machine.size
  admin_username      = var.linux_virtual_machine.admin_username

  # Network
  network_interface_ids = [azurerm_network_interface.this.id]

  # Authentication
  disable_password_authentication = var.linux_virtual_machine.disable_password_authentication
  admin_password                  = var.linux_virtual_machine.admin_password

  dynamic "admin_ssh_key" {
    for_each = var.linux_virtual_machine.admin_ssh_key != null ? [var.linux_virtual_machine.admin_ssh_key] : []
    content {
      username   = admin_ssh_key.value.username
      public_key = admin_ssh_key.value.public_key
    }
  }

  # OS Disk
  os_disk {
    name                 = var.linux_virtual_machine.os_disk.name
    caching              = var.linux_virtual_machine.os_disk.caching
    storage_account_type = var.linux_virtual_machine.os_disk.storage_account_type
    disk_size_gb         = var.linux_virtual_machine.os_disk.disk_size_gb

    dynamic "diff_disk_settings" {
      for_each = var.linux_virtual_machine.os_disk.diff_disk_settings != null ? [var.linux_virtual_machine.os_disk.diff_disk_settings] : []
      content {
        option    = diff_disk_settings.value.option
        placement = diff_disk_settings.value.placement
      }
    }
  }

  # Source Image
  dynamic "source_image_reference" {
    for_each = var.linux_virtual_machine.source_image_reference != null ? [var.linux_virtual_machine.source_image_reference] : []
    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  source_image_id = var.linux_virtual_machine.source_image_id

  # Boot Diagnostics
  dynamic "boot_diagnostics" {
    for_each = var.linux_virtual_machine.boot_diagnostics != null ? [var.linux_virtual_machine.boot_diagnostics] : []
    content {
      storage_account_uri = boot_diagnostics.value.storage_account_uri
    }
  }

  # Additional Disks
  dynamic "additional_capabilities" {
    for_each = var.linux_virtual_machine.additional_capabilities != null ? [var.linux_virtual_machine.additional_capabilities] : []
    content {
      ultra_ssd_enabled = additional_capabilities.value.ultra_ssd_enabled
    }
  }

  # Identity
  dynamic "identity" {
    for_each = var.linux_virtual_machine.identity != null ? [var.linux_virtual_machine.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  # Plan
  dynamic "plan" {
    for_each = var.linux_virtual_machine.plan != null ? [var.linux_virtual_machine.plan] : []
    content {
      name      = plan.value.name
      product   = plan.value.product
      publisher = plan.value.publisher
    }
  }

  # Custom Data
  custom_data = var.linux_virtual_machine.custom_data

  # VM Agent
  provision_vm_agent         = var.linux_virtual_machine.provision_vm_agent
  allow_extension_operations = var.linux_virtual_machine.allow_extension_operations

  # Availability
  availability_set_id                 = var.linux_virtual_machine.availability_set_id
  proximity_placement_group_id        = var.linux_virtual_machine.proximity_placement_group_id
  virtual_machine_scale_set_id        = var.linux_virtual_machine.virtual_machine_scale_set_id
  zone                                = var.linux_virtual_machine.zone
  encryption_at_host_enabled          = var.linux_virtual_machine.encryption_at_host_enabled
  extensions_time_budget              = var.linux_virtual_machine.extensions_time_budget
  patch_assessment_mode               = var.linux_virtual_machine.patch_assessment_mode
  patch_mode                          = var.linux_virtual_machine.patch_mode
  max_bid_price                       = var.linux_virtual_machine.max_bid_price
  priority                            = var.linux_virtual_machine.priority
  eviction_policy                     = var.linux_virtual_machine.eviction_policy
  dedicated_host_id                   = var.linux_virtual_machine.dedicated_host_id
  dedicated_host_group_id             = var.linux_virtual_machine.dedicated_host_group_id
  platform_fault_domain              = var.linux_virtual_machine.platform_fault_domain
  computer_name                       = var.linux_virtual_machine.computer_name
  secure_boot_enabled                 = var.linux_virtual_machine.secure_boot_enabled
  vtpm_enabled                        = var.linux_virtual_machine.vtpm_enabled

  tags = var.tags
} 