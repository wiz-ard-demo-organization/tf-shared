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
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_public_ip"></a> [public\_ip](#input\_public\_ip) | public\_ip = {<br/>  name : "(Required) Specifies the name of the Public IP resource. Changing this forces a new resource to be created."<br/>  location : "(Required) Specifies the Azure region where the resource exists. Changing this forces a new resource to be created."<br/>  resource\_group\_name : "(Required) The name of the resource group in which to create the Public IP. Changing this forces a new resource to be created."<br/>  allocation\_method : "(Required) The allocation method for the Public IP. Must be either Static or Dynamic. Changing this forces a new resource to be created."<br/>  sku : "(Optional) SKU of the Public IP. Possible values are Basic and Standard."<br/>  sku\_tier : "(Optional) SKU tier of the Public IP. Possible values are Regional and Global."<br/>  zones : "(Optional) A list of Availability Zones into which to provision the Public IP. Changing this forces a new resource to be created."<br/>  domain\_name\_label : "(Optional) A domain name label. Changing this forces a new resource to be created."<br/>  idle\_timeout\_in\_minutes : "(Optional) The timeout for idle connections in minutes."<br/>  ip\_version : "(Optional) The IP version. Possible values are IPv4 and IPv6."<br/>  ip\_tags : "(Optional) A mapping of IP tags."<br/>  public\_ip\_prefix\_id : "(Optional) The ID of the Public IP Prefix to associate."<br/>  reverse\_fqdn : "(Optional) The reverse FQDN of the Public IP."<br/>  edge\_zone : "(Optional) Edge zone in which to create the resource."<br/>  ddos\_protection\_mode : "(Optional) The DDOS protection mode. Possible values are Off, Alert, Deny."<br/>  ddos\_protection\_plan\_id : "(Optional) The ID of the DDOS protection plan to apply."<br/>} | <pre>object({<br/>    name                    = string<br/>    location                = string<br/>    resource_group_name     = string<br/>    allocation_method       = string<br/>    sku                     = optional(string)<br/>    sku_tier                = optional(string)<br/>    zones                   = optional(list(string))<br/>    domain_name_label       = optional(string)<br/>    idle_timeout_in_minutes = optional(number)<br/>    ip_version              = optional(string)<br/>    ip_tags                 = optional(map(string))<br/>    public_ip_prefix_id     = optional(string)<br/>    reverse_fqdn            = optional(string)<br/>    edge_zone               = optional(string)<br/>    ddos_protection_mode    = optional(string)<br/>    ddos_protection_plan_id = optional(string)<br/>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | The IP address value that was allocated |
| <a name="output_public_ip_fqdn"></a> [public\_ip\_fqdn](#output\_public\_ip\_fqdn) | The FQDN of the Public IP |
| <a name="output_public_ip_id"></a> [public\_ip\_id](#output\_public\_ip\_id) | The ID of the Public IP |
<!-- END_TF_DOCS -->