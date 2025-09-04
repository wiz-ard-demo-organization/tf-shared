# Module for creating and managing Azure Linux Virtual Machines with associated network interfaces, public IPs, and security configurations
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

module "vm_name" {
  source          = "../_global/modules/naming"
  key             = var.key
  settings        = var.settings
  global_settings = var.global_settings
  client_config   = var.client_config
  remote_states   = var.remote_states
  resource_type   = "azurerm_linux_virtual_machine"
}

module "nic_name" {
  source          = "../_global/modules/naming"
  key             = var.key
  settings        = var.settings
  global_settings = var.global_settings
  client_config   = var.client_config
  remote_states   = var.remote_states
  resource_type   = "azurerm_network_interface"
}

module "pip_name" {
  source          = "../_global/modules/naming"
  key             = var.key
  settings        = var.settings
  global_settings = var.global_settings
  client_config   = var.client_config
  remote_states   = var.remote_states
  resource_type   = "azurerm_public_ip"
}

locals {
  resource_group = can(var.settings.resource_group.state_key) ? try(var.remote_states[var.settings.resource_group.state_key].resource_groups[var.settings.resource_group.key], null) : try(var.resource_groups[var.settings.resource_group.key], null)
}

# Create optional public IP for the virtual machine if external access is required
resource "azurerm_public_ip" "this" {
  count = try(var.settings.create_public_ip, false) ? 1 : 0

  name                = try(var.settings.public_ip_config.name, module.pip_name.result)
  location            = try(var.settings.location, var.global_settings.location_name)
  resource_group_name = try(var.settings.resource_group_name, local.resource_group.name)
  allocation_method   = try(var.settings.public_ip_config.allocation_method, "Static")
  sku                 = try(var.settings.public_ip_config.sku, "Standard")
  zones               = try(var.settings.public_ip_config.zones, null)
  domain_name_label   = try(var.settings.public_ip_config.domain_name_label, null)
  idle_timeout_in_minutes = try(var.settings.public_ip_config.idle_timeout_in_minutes, 4)
  ip_version          = try(var.settings.public_ip_config.ip_version, "IPv4")

  tags = var.tags
}

# Create network interface for the virtual machine with IP configurations
resource "azurerm_network_interface" "this" {
  name                = try(var.settings.network_interface.name, module.nic_name.result)
  location            = try(var.settings.location, var.global_settings.location_name)
  resource_group_name = try(var.settings.resource_group_name, local.resource_group.name)

  # Configure IP settings for the network interface
  dynamic "ip_configuration" {
    for_each = var.settings.network_interface.ip_configuration
    content {
      name                          = ip_configuration.value.name
      subnet_id                     = ip_configuration.value.subnet_id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      private_ip_address            = ip_configuration.value.private_ip_address
      public_ip_address_id          = try(var.settings.create_public_ip, false) ? azurerm_public_ip.this[0].id : try(ip_configuration.value.public_ip_address_id, null)
      primary                       = ip_configuration.value.primary
    }
  }

  tags = var.tags
}

# Associate network security group with the network interface for firewall rules
resource "azurerm_network_interface_security_group_association" "this" {
  count = try(var.settings.network_security_group_id, null) != null ? 1 : 0

  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = var.settings.network_security_group_id
}

# Create the Linux Virtual Machine with specified configuration
resource "azurerm_linux_virtual_machine" "this" {
  name                = try(var.settings.name, module.vm_name.result)
  location            = try(var.settings.location, var.global_settings.location_name)
  resource_group_name = try(var.settings.resource_group_name, local.resource_group.name)
  size                = try(var.settings.size, null)
  admin_username      = try(var.settings.admin_username, null)

  # Network configuration
  network_interface_ids = [azurerm_network_interface.this.id]

  # Authentication configuration
  disable_password_authentication = try(var.settings.disable_password_authentication, null)
  admin_password                  = try(var.settings.admin_password, null)

  # SSH key configuration for secure access
  dynamic "admin_ssh_key" {
    for_each = try(var.settings.admin_ssh_key, null) != null ? [var.settings.admin_ssh_key] : []
    content {
      username   = admin_ssh_key.value.username
      public_key = admin_ssh_key.value.public_key
    }
  }

  # OS Disk configuration for the virtual machine
  os_disk {
    name                 = try(var.settings.os_disk.name, null)
    caching              = try(var.settings.os_disk.caching, null)
    storage_account_type = try(var.settings.os_disk.storage_account_type, null)
    disk_size_gb         = try(var.settings.os_disk.disk_size_gb, null)

    # Ephemeral disk settings for improved performance
    dynamic "diff_disk_settings" {
      for_each = try(var.settings.os_disk.diff_disk_settings, null) != null ? [var.settings.os_disk.diff_disk_settings] : []
      content {
        option    = diff_disk_settings.value.option
        placement = diff_disk_settings.value.placement
      }
    }
  }

  # Source image configuration from Azure Marketplace
  dynamic "source_image_reference" {
    for_each = try(var.settings.source_image_reference, null) != null ? [var.settings.source_image_reference] : []
    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  # Custom image ID if using a custom image
  source_image_id = try(var.settings.source_image_id, null)

  # Boot diagnostics configuration for troubleshooting
  dynamic "boot_diagnostics" {
    for_each = try(var.settings.boot_diagnostics, null) != null ? [var.settings.boot_diagnostics] : []
    content {
      storage_account_uri = boot_diagnostics.value.storage_account_uri
    }
  }

  # Additional capabilities like Ultra SSD support
  dynamic "additional_capabilities" {
    for_each = try(var.settings.additional_capabilities, null) != null ? [var.settings.additional_capabilities] : []
    content {
      ultra_ssd_enabled = additional_capabilities.value.ultra_ssd_enabled
    }
  }

  # Managed identity configuration for Azure resource access
  dynamic "identity" {
    for_each = try(var.settings.identity, null) != null ? [var.settings.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.type == "UserAssigned" ? identity.value.identity_ids : null
    }
  }

  # Marketplace image plan information
  dynamic "plan" {
    for_each = try(var.settings.plan, null) != null ? [var.settings.plan] : []
    content {
      name      = plan.value.name
      product   = plan.value.product
      publisher = plan.value.publisher
    }
  }

  # Custom data for cloud-init or other initialization scripts
  custom_data = try(var.settings.custom_data, null)

  # VM Agent configuration
  provision_vm_agent         = try(var.settings.provision_vm_agent, null)
  allow_extension_operations = try(var.settings.allow_extension_operations, null)

  # Availability and placement configuration
  availability_set_id                 = try(var.settings.availability_set_id, null)
  proximity_placement_group_id        = try(var.settings.proximity_placement_group_id, null)
  virtual_machine_scale_set_id        = try(var.settings.virtual_machine_scale_set_id, null)
  zone                                = try(var.settings.zone, null)
  encryption_at_host_enabled          = try(var.settings.encryption_at_host_enabled, null)
  extensions_time_budget              = try(var.settings.extensions_time_budget, null)
  patch_assessment_mode               = try(var.settings.patch_assessment_mode, null)
  patch_mode                          = try(var.settings.patch_mode, null)
  max_bid_price                       = try(var.settings.max_bid_price, null)
  priority                            = try(var.settings.priority, null)
  eviction_policy                     = try(var.settings.eviction_policy, null)
  dedicated_host_id                   = try(var.settings.dedicated_host_id, null)
  dedicated_host_group_id             = try(var.settings.dedicated_host_group_id, null)
  platform_fault_domain              = try(var.settings.platform_fault_domain, null)
  computer_name                       = try(var.settings.computer_name, null)
  secure_boot_enabled                 = try(var.settings.secure_boot_enabled, null)
  vtpm_enabled                        = try(var.settings.vtpm_enabled, null)

  tags = var.tags
} 