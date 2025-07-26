# Secure Cloud Foundation

This repository contains the Terraform code for the following components of the Landing Zone:

## Azure Policy Assignment 
Policy assignments are used by Azure Policy to define which resources are assigned which policies or initiatives.

This Module Manages a Policy Assignment to a Management Group.

*If applying policies to management groups the id should be set to /providers/Microsoft.Management/managementGroups/group_id*

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_name"></a> [name](#module\_name) | ../_global/modules/naming | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_management_group_policy_assignment.policyset_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_config"></a> [client\_config](#input\_client\_config) | Data source to access the configurations of the Azurerm provider | `any` | `{}` | no |
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | Global configurations for the Azure Landing Zone | `any` | `{}` | no |
| <a name="input_key"></a> [key](#input\_key) | Identifies the specific resource instance being deployed | `string` | `null` | no |
| <a name="input_policy_definition_id"></a> [policy\_definition\_id](#input\_policy\_definition\_id) | The id of the policy set (initiative) definition to assign. | `string` | n/a | yes |
| <a name="input_remote_states"></a> [remote\_states](#input\_remote\_states) | Outputs from the previous deployments that are stored in additional Terraform State Files | `any` | `{}` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Provides the configuration values for the specific resources being deployed | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Management Group Policy Assignment |
