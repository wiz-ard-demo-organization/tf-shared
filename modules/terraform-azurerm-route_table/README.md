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
| [azurerm_route.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_route_table"></a> [route\_table](#input\_route\_table) | Configuration for the Route Table | <pre>object({<br/>    name                          = string<br/>    location                      = string<br/>    resource_group_name           = string<br/>    disable_bgp_route_propagation = optional(bool, false)<br/>  })</pre> | n/a | yes |
| <a name="input_routes"></a> [routes](#input\_routes) | Map of routes to create in the route table | <pre>map(object({<br/>    name                   = string<br/>    address_prefix         = string<br/>    next_hop_type          = string<br/>    next_hop_in_ip_address = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to all resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_route_table"></a> [route\_table](#output\_route\_table) | The Route Table resource |
| <a name="output_routes"></a> [routes](#output\_routes) | Map of routes in the route table |
<!-- END_TF_DOCS -->