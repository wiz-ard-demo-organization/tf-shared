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
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnets to create within the virtual network | <pre>map(object({<br/>    name                                          = string<br/>    address_prefixes                              = list(string)<br/>    private_endpoint_network_policies_enabled    = optional(bool)<br/>    private_link_service_network_policies_enabled = optional(bool)<br/>    service_endpoints                             = optional(list(string))<br/>    service_endpoint_policy_ids                   = optional(list(string))<br/><br/>    delegation = optional(object({<br/>      name = string<br/>      service_delegation = object({<br/>        name    = string<br/>        actions = optional(list(string))<br/>      })<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to all resources | `map(string)` | n/a | yes |
| <a name="input_virtual_network"></a> [virtual\_network](#input\_virtual\_network) | Configuration for the Azure Virtual Network | <pre>object({<br/>    name                    = string<br/>    location                = string<br/>    resource_group_name     = string<br/>    address_space           = list(string)<br/>    dns_servers             = optional(list(string))<br/>    edge_zone               = optional(string)<br/>    flow_timeout_in_minutes = optional(number)<br/><br/>    ddos_protection_plan = optional(object({<br/>      id     = string<br/>      enable = bool<br/>    }))<br/><br/>    encryption = optional(object({<br/>      enforcement = string<br/>    }))<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#output\_subnet\_address\_prefixes) | Map of subnet names to their address prefixes |
| <a name="output_subnet_details"></a> [subnet\_details](#output\_subnet\_details) | Detailed information about all subnets |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Map of subnet names to their IDs |
| <a name="output_subnet_names"></a> [subnet\_names](#output\_subnet\_names) | Map of subnet keys to their names |
| <a name="output_virtual_network_address_space"></a> [virtual\_network\_address\_space](#output\_virtual\_network\_address\_space) | The list of address spaces used by the Virtual Network |
| <a name="output_virtual_network_dns_servers"></a> [virtual\_network\_dns\_servers](#output\_virtual\_network\_dns\_servers) | The list of DNS servers used by the Virtual Network |
| <a name="output_virtual_network_guid"></a> [virtual\_network\_guid](#output\_virtual\_network\_guid) | The GUID of the Virtual Network |
| <a name="output_virtual_network_id"></a> [virtual\_network\_id](#output\_virtual\_network\_id) | The ID of the Virtual Network |
| <a name="output_virtual_network_location"></a> [virtual\_network\_location](#output\_virtual\_network\_location) | The location of the Virtual Network |
| <a name="output_virtual_network_name"></a> [virtual\_network\_name](#output\_virtual\_network\_name) | The name of the Virtual Network |
<!-- END_TF_DOCS -->