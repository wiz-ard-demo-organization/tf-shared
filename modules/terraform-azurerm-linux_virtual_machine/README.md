<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_linux_virtual_machine"></a> [linux\_virtual\_machine](#input\_linux\_virtual\_machine) | Configuration for the Linux Virtual Machine | <pre>object({<br/>    name                            = string<br/>    location                        = string<br/>    resource_group_name             = string<br/>    size                            = string<br/>    admin_username                  = string<br/>    create_public_ip                = optional(bool, false)<br/>    disable_password_authentication = optional(bool, true)<br/>    admin_password                  = optional(string)<br/>    <br/>    admin_ssh_key = optional(object({<br/>      username   = string<br/>      public_key = string<br/>    }))<br/>    <br/>    os_disk = object({<br/>      name                 = optional(string)<br/>      caching              = string<br/>      storage_account_type = string<br/>      disk_size_gb         = optional(number)<br/>      <br/>      diff_disk_settings = optional(object({<br/>        option    = string<br/>        placement = optional(string)<br/>      }))<br/>    })<br/>    <br/>    source_image_reference = optional(object({<br/>      publisher = string<br/>      offer     = string<br/>      sku       = string<br/>      version   = string<br/>    }))<br/>    <br/>    source_image_id = optional(string)<br/>    <br/>    boot_diagnostics = optional(object({<br/>      storage_account_uri = optional(string)<br/>    }))<br/>    <br/>    additional_capabilities = optional(object({<br/>      ultra_ssd_enabled = optional(bool, false)<br/>    }))<br/>    <br/>    identity = optional(object({<br/>      type         = string<br/>      identity_ids = optional(list(string))<br/>    }))<br/>    <br/>    plan = optional(object({<br/>      name      = string<br/>      product   = string<br/>      publisher = string<br/>    }))<br/>    <br/>    custom_data                         = optional(string)<br/>    provision_vm_agent                  = optional(bool, true)<br/>    allow_extension_operations          = optional(bool, true)<br/>    availability_set_id                 = optional(string)<br/>    proximity_placement_group_id        = optional(string)<br/>    virtual_machine_scale_set_id        = optional(string)<br/>    zone                                = optional(string)<br/>    encryption_at_host_enabled          = optional(bool, false)<br/>    extensions_time_budget              = optional(string)<br/>    patch_assessment_mode               = optional(string)<br/>    patch_mode                          = optional(string)<br/>    max_bid_price                       = optional(number)<br/>    priority                            = optional(string, "Regular")<br/>    eviction_policy                     = optional(string)<br/>    dedicated_host_id                   = optional(string)<br/>    dedicated_host_group_id             = optional(string)<br/>    platform_fault_domain              = optional(number)<br/>    computer_name                       = optional(string)<br/>    secure_boot_enabled                 = optional(bool)<br/>    vtpm_enabled                        = optional(bool)<br/>  })</pre> | n/a | yes |
| <a name="input_network_interface"></a> [network\_interface](#input\_network\_interface) | Configuration for the Network Interface | <pre>object({<br/>    name = string<br/>    <br/>    ip_configuration = list(object({<br/>      name                          = string<br/>      subnet_id                     = string<br/>      private_ip_address_allocation = string<br/>      private_ip_address            = optional(string)<br/>      public_ip_address_id          = optional(string)<br/>      primary                       = optional(bool, true)<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_network_security_group_id"></a> [network\_security\_group\_id](#input\_network\_security\_group\_id) | ID of the Network Security Group to associate with the Network Interface | `string` | `null` | no |
| <a name="input_public_ip_config"></a> [public\_ip\_config](#input\_public\_ip\_config) | Configuration for the Public IP (when create\_public\_ip is true) | <pre>object({<br/>    name                    = string<br/>    allocation_method       = string<br/>    sku                     = optional(string, "Standard")<br/>    zones                   = optional(list(string))<br/>    domain_name_label       = optional(string)<br/>    idle_timeout_in_minutes = optional(number, 4)<br/>    ip_version              = optional(string, "IPv4")<br/>  })</pre> | <pre>{<br/>  "allocation_method": "Static",<br/>  "name": "default-pip",<br/>  "sku": "Standard"<br/>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to all resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_interface_id"></a> [network\_interface\_id](#output\_network\_interface\_id) | The ID of the Network Interface |
| <a name="output_network_interface_private_ip_address"></a> [network\_interface\_private\_ip\_address](#output\_network\_interface\_private\_ip\_address) | The first private IP address of the network interface |
| <a name="output_network_interface_private_ip_addresses"></a> [network\_interface\_private\_ip\_addresses](#output\_network\_interface\_private\_ip\_addresses) | The private IP addresses of the network interface |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | The IP address value that was allocated for the Public IP |
| <a name="output_public_ip_fqdn"></a> [public\_ip\_fqdn](#output\_public\_ip\_fqdn) | The FQDN associated with the Public IP |
| <a name="output_public_ip_id"></a> [public\_ip\_id](#output\_public\_ip\_id) | The ID of the Public IP |
| <a name="output_virtual_machine_id"></a> [virtual\_machine\_id](#output\_virtual\_machine\_id) | The ID of the Linux Virtual Machine |
| <a name="output_virtual_machine_identity"></a> [virtual\_machine\_identity](#output\_virtual\_machine\_identity) | The identity block of the Linux Virtual Machine |
| <a name="output_virtual_machine_name"></a> [virtual\_machine\_name](#output\_virtual\_machine\_name) | The name of the Linux Virtual Machine |
| <a name="output_virtual_machine_private_ip_address"></a> [virtual\_machine\_private\_ip\_address](#output\_virtual\_machine\_private\_ip\_address) | The primary private IP address of the Linux Virtual Machine |
| <a name="output_virtual_machine_private_ip_addresses"></a> [virtual\_machine\_private\_ip\_addresses](#output\_virtual\_machine\_private\_ip\_addresses) | The list of private IP addresses of the Linux Virtual Machine |
| <a name="output_virtual_machine_public_ip_address"></a> [virtual\_machine\_public\_ip\_address](#output\_virtual\_machine\_public\_ip\_address) | The primary public IP address of the Linux Virtual Machine |
| <a name="output_virtual_machine_public_ip_addresses"></a> [virtual\_machine\_public\_ip\_addresses](#output\_virtual\_machine\_public\_ip\_addresses) | The list of public IP addresses of the Linux Virtual Machine |
<!-- END_TF_DOCS -->