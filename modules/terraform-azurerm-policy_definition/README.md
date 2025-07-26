<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3 |

## Resources

| Name | Type |
|------|------|
| [azurerm_policy_definition.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_config"></a> [client\_config](#input\_client\_config) | Data source to access the configurations of the Azurerm provider | `any` | `{}` | no |
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | Global configurations for the Azure Landing Zone | `any` | `{}` | no |
| <a name="input_key"></a> [key](#input\_key) | Identifies the specific resource instance being deployed | `string` | `null` | no |
| <a name="input_remote_states"></a> [remote\_states](#input\_remote\_states) | Outputs from the previous deployments that are stored in additional Terraform State Files | `any` | `{}` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Provides the configuration values for the specific resources being deployed | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Policy Definition |
<!-- END_TF_DOCS -->