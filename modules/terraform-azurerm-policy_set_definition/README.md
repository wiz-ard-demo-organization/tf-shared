# Secure Cloud Foundation

This repository contains the Terraform code for the following components of the Landing Zone:

## Azure Policy Initiative (Set Definitions) Module
An Azure initiative is a collection of Azure policy definitions that are grouped together towards a specific goal or purpose in mind. Azure initiatives simplify management of your policies by grouping a set of policies together as one single item.

This Module Manages a policy set definition.

*Policy set definitions (also known as policy initiatives) do not take effect until they are assigned to a scope using a Policy Set Assignment.*

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_name"></a> [name](#module\_name) | ../_global/modules/naming | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_policy_set_definition.policyset](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_set_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_config"></a> [client\_config](#input\_client\_config) | Data source to access the configurations of the Azurerm provider | `any` | `{}` | no |
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | Global configurations for the Azure Landing Zone | `any` | `{}` | no |
| <a name="input_key"></a> [key](#input\_key) | Identifies the specific resource instance being deployed | `string` | `null` | no |
| <a name="input_policy_definitions"></a> [policy\_definitions](#input\_policy\_definitions) | The list of policy\_definition\_reference. | `list(any)` | n/a | yes |
| <a name="input_remote_states"></a> [remote\_states](#input\_remote\_states) | Outputs from the previous deployments that are stored in additional Terraform State Files | `any` | `{}` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Provides the configuration values for the specific resources being deployed | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Policy Set Definition |
