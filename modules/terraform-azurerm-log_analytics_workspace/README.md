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
| [azurerm_log_analytics_data_export_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_data_export_rule) | resource |
| [azurerm_log_analytics_query_pack.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_query_pack) | resource |
| [azurerm_log_analytics_query_pack_query.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_saved_search.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_saved_search) | resource |
| [azurerm_log_analytics_solution.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_data_export_rules"></a> [data\_export\_rules](#input\_data\_export\_rules) | Map of data export rules for the Log Analytics workspace | <pre>map(object({<br/>    name                    = string<br/>    destination_resource_id = string<br/>    table_names             = list(string)<br/>    enabled                 = optional(bool, true)<br/>  }))</pre> | `{}` | no |
| <a name="input_log_analytics_solutions"></a> [log\_analytics\_solutions](#input\_log\_analytics\_solutions) | Map of Log Analytics solutions to deploy | <pre>map(object({<br/>    solution_name = string<br/>    plan = object({<br/>      publisher = string<br/>      product   = string<br/>    })<br/>  }))</pre> | `{}` | no |
| <a name="input_log_analytics_workspace"></a> [log\_analytics\_workspace](#input\_log\_analytics\_workspace) | Configuration for the Log Analytics Workspace | <pre>object({<br/>    name                       = string<br/>    location                   = string<br/>    resource_group_name        = string<br/>    sku                        = string<br/>    retention_in_days          = optional(number)<br/>    daily_quota_gb             = optional(number)<br/>    internet_ingestion_enabled = optional(bool, true)<br/>    internet_query_enabled     = optional(bool, true)<br/>    reservation_capacity_in_gb_per_day = optional(number)<br/>    data_collection_rule_id    = optional(string)<br/>    immediate_data_purge_on_30_days_enabled = optional(bool, false)<br/>    local_authentication_disabled = optional(bool, false)<br/>    cmk_for_query_forced       = optional(bool, false)<br/><br/>    identity = optional(object({<br/>      type         = string<br/>      identity_ids = optional(list(string))<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_query_pack_queries"></a> [query\_pack\_queries](#input\_query\_pack\_queries) | Map of queries to add to query packs | <pre>map(object({<br/>    query_pack_key           = string<br/>    body                     = string<br/>    display_name             = string<br/>    name                     = string<br/>    description              = optional(string)<br/>    categories               = optional(list(string))<br/>    resource_types           = optional(list(string))<br/>    solutions                = optional(list(string))<br/>    tags                     = optional(map(string))<br/>    additional_settings_json = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_query_packs"></a> [query\_packs](#input\_query\_packs) | Map of query packs to create | <pre>map(object({<br/>    name = string<br/>  }))</pre> | `{}` | no |
| <a name="input_saved_searches"></a> [saved\_searches](#input\_saved\_searches) | Map of saved searches for the Log Analytics workspace | <pre>map(object({<br/>    name                = string<br/>    category            = string<br/>    display_name        = string<br/>    query               = string<br/>    function_alias      = optional(string)<br/>    function_parameters = optional(list(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to all resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_data_export_rules"></a> [data\_export\_rules](#output\_data\_export\_rules) | Map of data export rules |
| <a name="output_log_analytics_solutions"></a> [log\_analytics\_solutions](#output\_log\_analytics\_solutions) | Map of deployed Log Analytics solutions |
| <a name="output_log_analytics_workspace"></a> [log\_analytics\_workspace](#output\_log\_analytics\_workspace) | The Log Analytics Workspace resource |
| <a name="output_query_pack_queries"></a> [query\_pack\_queries](#output\_query\_pack\_queries) | Map of query pack queries |
| <a name="output_query_packs"></a> [query\_packs](#output\_query\_packs) | Map of query packs |
| <a name="output_saved_searches"></a> [saved\_searches](#output\_saved\_searches) | Map of saved searches |
<!-- END_TF_DOCS -->