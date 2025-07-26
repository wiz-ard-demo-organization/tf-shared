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
| [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_diagnostic_setting"></a> [diagnostic\_setting](#input\_diagnostic\_setting) | Configuration for Azure Monitor Diagnostic Settings | <pre>object({<br/>    name                           = string<br/>    target_resource_id             = string<br/>    log_analytics_workspace_id     = optional(string)<br/>    log_analytics_destination_type = optional(string)<br/>    storage_account_id             = optional(string)<br/>    eventhub_name                  = optional(string)<br/>    eventhub_authorization_rule_id = optional(string)<br/>    partner_solution_id            = optional(string)<br/>    <br/>    enabled_log = optional(list(object({<br/>      category       = optional(string)<br/>      category_group = optional(string)<br/>      <br/>      retention_policy = optional(object({<br/>        enabled = bool<br/>        days    = optional(number)<br/>      }))<br/>    })))<br/>    <br/>    metric = optional(list(object({<br/>      category = string<br/>      enabled  = optional(bool, true)<br/>      <br/>      retention_policy = optional(object({<br/>        enabled = bool<br/>        days    = optional(number)<br/>      }))<br/>    })))<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_diagnostic_setting_id"></a> [diagnostic\_setting\_id](#output\_diagnostic\_setting\_id) | The ID of the Diagnostic Setting |
| <a name="output_diagnostic_setting_name"></a> [diagnostic\_setting\_name](#output\_diagnostic\_setting\_name) | The name of the Diagnostic Setting |
| <a name="output_eventhub_authorization_rule_id"></a> [eventhub\_authorization\_rule\_id](#output\_eventhub\_authorization\_rule\_id) | The ID of the Event Hub Authorization Rule if configured |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | The ID of the Log Analytics Workspace if configured |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | The ID of the Storage Account if configured |
<!-- END_TF_DOCS -->