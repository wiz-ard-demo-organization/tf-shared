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
| [azurerm_virtual_network_peering.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_peering"></a> [peering](#input\_peering) | Configuration for the virtual network peering | <pre>object({<br/>    name                         = string<br/>    resource_group_name          = string<br/>    virtual_network_name         = string<br/>    remote_virtual_network_id    = string<br/>    allow_virtual_network_access = optional(bool)<br/>    allow_forwarded_traffic      = optional(bool)<br/>    allow_gateway_transit        = optional(bool)<br/>    use_remote_gateways          = optional(bool)<br/>    triggers                     = optional(map(string))<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_peering_id"></a> [peering\_id](#output\_peering\_id) | The ID of the virtual network peering |
| <a name="output_peering_name"></a> [peering\_name](#output\_peering\_name) | The name of the virtual network peering |
| <a name="output_resource_guid"></a> [resource\_guid](#output\_resource\_guid) | The resource GUID of the virtual network peering |
<!-- END_TF_DOCS -->