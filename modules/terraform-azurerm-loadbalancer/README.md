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
| [azurerm_lb.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_backend_address_pool_address.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool_address) | resource |
| [azurerm_lb_nat_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_nat_pool) | resource |
| [azurerm_lb_nat_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_nat_rule) | resource |
| [azurerm_lb_outbound_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_outbound_rule) | resource |
| [azurerm_lb_probe.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_address_pool_addresses"></a> [backend\_address\_pool\_addresses](#input\_backend\_address\_pool\_addresses) | Map of backend address pool addresses | <pre>map(object({<br/>    name                       = string<br/>    backend_address_pool_key   = string<br/>    virtual_network_id         = string<br/>    ip_address                 = string<br/><br/>    inbound_nat_rule_port_mapping = optional(list(object({<br/>      inbound_nat_rule_name = string<br/>      frontend_port         = number<br/>      backend_port          = number<br/>    })))<br/>  }))</pre> | `{}` | no |
| <a name="input_backend_address_pools"></a> [backend\_address\_pools](#input\_backend\_address\_pools) | Map of backend address pools to create | <pre>map(object({<br/>    name = string<br/><br/>    tunnel_interface = optional(list(object({<br/>      identifier = number<br/>      type       = string<br/>      protocol   = string<br/>      port       = number<br/>    })))<br/>  }))</pre> | `{}` | no |
| <a name="input_health_probes"></a> [health\_probes](#input\_health\_probes) | Map of health probes to create | <pre>map(object({<br/>    name                = string<br/>    protocol            = string<br/>    port                = number<br/>    probe_threshold     = optional(number)<br/>    request_path        = optional(string)<br/>    interval_in_seconds = optional(number)<br/>    number_of_probes    = optional(number)<br/>  }))</pre> | `{}` | no |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | Configuration for the Azure Load Balancer | <pre>object({<br/>    name                = string<br/>    location            = string<br/>    resource_group_name = string<br/>    sku                 = optional(string)<br/>    sku_tier            = optional(string)<br/>    edge_zone           = optional(string)<br/><br/>    frontend_ip_configuration = list(object({<br/>      name                          = string<br/>      zones                         = optional(list(string))<br/>      subnet_id                     = optional(string)<br/>      private_ip_address            = optional(string)<br/>      private_ip_address_allocation = optional(string)<br/>      private_ip_address_version    = optional(string)<br/>      public_ip_address_id          = optional(string)<br/>      public_ip_prefix_id           = optional(string)<br/>      gateway_load_balancer_frontend_ip_configuration_id = optional(string)<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_load_balancing_rules"></a> [load\_balancing\_rules](#input\_load\_balancing\_rules) | Map of load balancing rules to create | <pre>map(object({<br/>    name                           = string<br/>    protocol                       = string<br/>    frontend_port                  = number<br/>    backend_port                   = number<br/>    frontend_ip_configuration_name = string<br/>    backend_address_pool_keys      = list(string)<br/>    probe_key                      = optional(string)<br/>    enable_floating_ip             = optional(bool)<br/>    idle_timeout_in_minutes        = optional(number)<br/>    load_distribution              = optional(string)<br/>    disable_outbound_snat          = optional(bool)<br/>    enable_tcp_reset               = optional(bool)<br/>  }))</pre> | `{}` | no |
| <a name="input_nat_pools"></a> [nat\_pools](#input\_nat\_pools) | Map of NAT pools to create (for Virtual Machine Scale Sets) | <pre>map(object({<br/>    name                           = string<br/>    protocol                       = string<br/>    frontend_port_start            = number<br/>    frontend_port_end              = number<br/>    backend_port                   = number<br/>    frontend_ip_configuration_name = string<br/>    idle_timeout_in_minutes        = optional(number)<br/>    floating_ip_enabled            = optional(bool)<br/>    tcp_reset_enabled              = optional(bool)<br/>  }))</pre> | `{}` | no |
| <a name="input_nat_rules"></a> [nat\_rules](#input\_nat\_rules) | Map of NAT rules to create | <pre>map(object({<br/>    name                           = string<br/>    protocol                       = string<br/>    frontend_port                  = number<br/>    backend_port                   = number<br/>    frontend_ip_configuration_name = string<br/>    idle_timeout_in_minutes        = optional(number)<br/>    enable_floating_ip             = optional(bool)<br/>    enable_tcp_reset               = optional(bool)<br/>  }))</pre> | `{}` | no |
| <a name="input_outbound_rules"></a> [outbound\_rules](#input\_outbound\_rules) | Map of outbound rules to create | <pre>map(object({<br/>    name                            = string<br/>    protocol                        = string<br/>    backend_address_pool_key        = string<br/>    frontend_ip_configuration_names = list(string)<br/>    allocated_outbound_ports        = optional(number)<br/>    idle_timeout_in_minutes         = optional(number)<br/>    enable_tcp_reset                = optional(bool)<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to all resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_address_pool_details"></a> [backend\_address\_pool\_details](#output\_backend\_address\_pool\_details) | Detailed information about all Backend Address Pools |
| <a name="output_backend_address_pool_ids"></a> [backend\_address\_pool\_ids](#output\_backend\_address\_pool\_ids) | The IDs of the Backend Address Pools |
| <a name="output_backend_address_pool_names"></a> [backend\_address\_pool\_names](#output\_backend\_address\_pool\_names) | The names of the Backend Address Pools |
| <a name="output_health_probe_details"></a> [health\_probe\_details](#output\_health\_probe\_details) | Detailed information about all Health Probes |
| <a name="output_health_probe_ids"></a> [health\_probe\_ids](#output\_health\_probe\_ids) | The IDs of the Health Probes |
| <a name="output_load_balancer_frontend_ip_configurations"></a> [load\_balancer\_frontend\_ip\_configurations](#output\_load\_balancer\_frontend\_ip\_configurations) | The frontend IP configurations of the Load Balancer |
| <a name="output_load_balancer_id"></a> [load\_balancer\_id](#output\_load\_balancer\_id) | The ID of the Load Balancer |
| <a name="output_load_balancer_name"></a> [load\_balancer\_name](#output\_load\_balancer\_name) | The name of the Load Balancer |
| <a name="output_load_balancer_private_ip_address"></a> [load\_balancer\_private\_ip\_address](#output\_load\_balancer\_private\_ip\_address) | The first private IP address assigned to the load balancer in frontend\_ip\_configuration blocks |
| <a name="output_load_balancer_private_ip_addresses"></a> [load\_balancer\_private\_ip\_addresses](#output\_load\_balancer\_private\_ip\_addresses) | The list of private IP addresses assigned to the load balancer in frontend\_ip\_configuration blocks |
| <a name="output_load_balancer_sku"></a> [load\_balancer\_sku](#output\_load\_balancer\_sku) | The SKU of the Load Balancer |
| <a name="output_load_balancing_rule_details"></a> [load\_balancing\_rule\_details](#output\_load\_balancing\_rule\_details) | Detailed information about all Load Balancing Rules |
| <a name="output_load_balancing_rule_ids"></a> [load\_balancing\_rule\_ids](#output\_load\_balancing\_rule\_ids) | The IDs of the Load Balancing Rules |
| <a name="output_nat_pool_details"></a> [nat\_pool\_details](#output\_nat\_pool\_details) | Detailed information about all NAT Pools |
| <a name="output_nat_pool_ids"></a> [nat\_pool\_ids](#output\_nat\_pool\_ids) | The IDs of the NAT Pools |
| <a name="output_nat_rule_details"></a> [nat\_rule\_details](#output\_nat\_rule\_details) | Detailed information about all NAT Rules |
| <a name="output_nat_rule_ids"></a> [nat\_rule\_ids](#output\_nat\_rule\_ids) | The IDs of the NAT Rules |
| <a name="output_outbound_rule_details"></a> [outbound\_rule\_details](#output\_outbound\_rule\_details) | Detailed information about all Outbound Rules |
| <a name="output_outbound_rule_ids"></a> [outbound\_rule\_ids](#output\_outbound\_rule\_ids) | The IDs of the Outbound Rules |
<!-- END_TF_DOCS -->