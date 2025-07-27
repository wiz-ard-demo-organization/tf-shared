# Secure Cloud Foundation

This repository contains the Terraform code for the following components of the Landing Zone:

## Level 2: Core Platform Connectivity

### Hub
This folder contains the resources like RG, Virtual Network, Subnets, NSG and Route Table that are to be provisioned in Connectivity subscription to help Connectivity.

In Platform level 2, source code modules from CoreShared/terraform-azurerm-platform-infra are being called to provision required resources.
The terraform folder contains the source code and the .azuredevops folder is the pipelines to run in Azure Devops Environment.

The following resources will be provisioned:
1.  Resource Groups
2.  Virtual Network
3.  Subnet
4.  NSG
5.  Route table

## Requirements

| Name                                                                | Version   |
| ------------------------------------------------------------------- | --------- |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.15.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3      |

## Providers

| Name                                                          | Version   |
| ------------------------------------------------------------- | --------- |
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 2.15.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3      |

## Modules

| Name                                                                                                          | Source                                                                    | Version |
| ------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- | ------- |
| <a name="module_network_security_groups"></a> [network\_security\_groups](#module\_network\_security\_groups) | ./modules/terraform-azurerm-platform-infra/modules/network_security_group | n/a     |
| <a name="module_resource_groups"></a> [resource\_groups](#module\_resource\_groups)                           | ./modules/terraform-azurerm-platform-infra/modules/resource_group         | n/a     |
| <a name="module_route_tables"></a> [route\_tables](#module\_route\_tables)                                    | ./modules/terraform-azurerm-platform-infra/modules/route_table            | n/a     |
| <a name="module_subnets"></a> [subnets](#module\_subnets)                                                     | ./modules/terraform-azurerm-platform-infra/modules/subnet                 | n/a     |
| <a name="module_virtual_networks"></a> [virtual\_networks](#module\_virtual\_networks)                        | ./modules/terraform-azurerm-platform-infra/modules/virtual_network        | n/a     |

## Resources

| Name                                                                                                                              | Type        |
| --------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription)   | data source |

## Inputs

| Name                                                                                                        | Description                                                                               | Type     | Default | Required |
| ----------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | -------- | ------- | :------: |
| <a name="input_client_config"></a> [client\_config](#input\_client\_config)                                 | Global configurations for the Azure Landing Zone                                          | `any`    | `null`  |    no    |
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings)                           | Identifies the specific resource instance being deployed                                  | `any`    | `null`  |    no    |
| <a name="input_key"></a> [key](#input\_key)                                                                 | Data source to access the configurations of the Azurerm provider                          | `string` | `null`  |    no    |
| <a name="input_network_security_groups"></a> [network\_security\_groups](#input\_network\_security\_groups) | Network Security Groups created and being referenced with an Instance key                 | `any`    | `{}`    |    no    |
| <a name="input_remote_states"></a> [remote\_states](#input\_remote\_states)                                 | Outputs from the previous deployments that are stored in additional Terraform State Files | `any`    | `{}`    |    no    |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups)                           | Resource Groups created and being referenced with an Instance key                         | `any`    | `{}`    |    no    |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables)                                    | Route tables created and being referenced with an Instance key                            | `any`    | `{}`    |    no    |
| <a name="input_settings"></a> [settings](#input\_settings)                                                  | Provides the configuration values for the specific resources being deployed               | `any`    | `{}`    |    no    |
| <a name="input_subnets"></a> [subnets](#input\_subnets)                                                     | Subnets created and being referenced with an Instance key                                 | `any`    | `{}`    |    no    |
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks)                        | Virtual Networks created and being referenced with an Instance key                        | `any`    | `{}`    |    no    |

## Outputs

| Name                                                                                                          | Description                                        |
| ------------------------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| <a name="output_network_security_groups"></a> [network\_security\_groups](#output\_network\_security\_groups) | Network security groups created as part of level 2 |
| <a name="output_resource_groups"></a> [resource\_groups](#output\_resource\_groups)                           | Resource groups created as part of level 2         |
| <a name="output_route_tables"></a> [route\_tables](#output\_route\_tables)                                    | Route Tables created as part of level 2            |
| <a name="output_subnets"></a> [subnets](#output\_subnets)                                                     | Subnets created as part of level 2                 |
| <a name="output_virtual_networks"></a> [virtual\_networks](#output\_virtual\_networks)                        | Virtual Networks created as part of level 2        |