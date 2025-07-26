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
| [azurerm_private_dns_a_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_private_dns_a_records"></a> [private\_dns\_a\_records](#input\_private\_dns\_a\_records) | Map of Private DNS A Records to create | <pre>map(object({<br/>    name                 = string<br/>    private_dns_zone_key = string<br/>    ttl                  = optional(number, 300)<br/>    records              = list(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_private_dns_zone_virtual_network_links"></a> [private\_dns\_zone\_virtual\_network\_links](#input\_private\_dns\_zone\_virtual\_network\_links) | Map of Private DNS Zone Virtual Network Links | <pre>map(object({<br/>    name                 = string<br/>    private_dns_zone_key = string<br/>    virtual_network_id   = string<br/>    registration_enabled = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_private_dns_zones"></a> [private\_dns\_zones](#input\_private\_dns\_zones) | Map of Private DNS Zones to create | <pre>map(object({<br/>    name = string<br/><br/>    soa_record = optional(object({<br/>      email         = string<br/>      expire_time   = optional(number)<br/>      minimum_ttl   = optional(number)<br/>      refresh_time  = optional(number)<br/>      retry_time    = optional(number)<br/>      serial_number = optional(number)<br/>      ttl           = optional(number)<br/>      tags          = optional(map(string))<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint) | Configuration for the Private Endpoint | <pre>object({<br/>    name                          = string<br/>    location                      = string<br/>    resource_group_name           = string<br/>    subnet_id                     = string<br/>    custom_network_interface_name = optional(string)<br/><br/>    private_service_connection = object({<br/>      name                              = string<br/>      private_connection_resource_id    = optional(string)<br/>      group_ids                         = optional(list(string))<br/>      subresource_names                 = optional(list(string))<br/>      is_manual_connection              = optional(bool, false)<br/>      private_connection_resource_alias = optional(string)<br/>      request_message                   = optional(string)<br/>    })<br/><br/>    private_dns_zone_group = optional(object({<br/>      name                 = string<br/>      private_dns_zone_ids = list(string)<br/>    }))<br/><br/>    ip_configuration = optional(list(object({<br/>      name               = string<br/>      private_ip_address = string<br/>      subresource_name   = optional(string)<br/>      member_name        = optional(string)<br/>    })))<br/>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to all resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_dns_a_records"></a> [private\_dns\_a\_records](#output\_private\_dns\_a\_records) | Map of Private DNS A Records |
| <a name="output_private_dns_zone_virtual_network_links"></a> [private\_dns\_zone\_virtual\_network\_links](#output\_private\_dns\_zone\_virtual\_network\_links) | Map of Private DNS Zone Virtual Network Links |
| <a name="output_private_dns_zones"></a> [private\_dns\_zones](#output\_private\_dns\_zones) | Map of created Private DNS Zones |
| <a name="output_private_endpoint"></a> [private\_endpoint](#output\_private\_endpoint) | The Private Endpoint resource |
<!-- END_TF_DOCS -->