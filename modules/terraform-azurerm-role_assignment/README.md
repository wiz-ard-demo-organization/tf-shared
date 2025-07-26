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
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments) | Map of role assignments to create | <pre>map(object({<br/>    scope                            = string<br/>    role_definition_name             = optional(string)<br/>    role_definition_id               = optional(string)<br/>    principal_id                     = string<br/>    principal_type                   = optional(string)<br/>    condition                        = optional(string)<br/>    condition_version                = optional(string)<br/>    description                      = optional(string)<br/>    skip_service_principal_aad_check = optional(bool, false)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_assignment_details"></a> [role\_assignment\_details](#output\_role\_assignment\_details) | Detailed information about all role assignments |
| <a name="output_role_assignment_ids"></a> [role\_assignment\_ids](#output\_role\_assignment\_ids) | Map of role assignment names to their IDs |
| <a name="output_role_assignment_principal_ids"></a> [role\_assignment\_principal\_ids](#output\_role\_assignment\_principal\_ids) | Map of role assignment names to their principal IDs |
| <a name="output_role_assignment_scopes"></a> [role\_assignment\_scopes](#output\_role\_assignment\_scopes) | Map of role assignment names to their scopes |
<!-- END_TF_DOCS -->