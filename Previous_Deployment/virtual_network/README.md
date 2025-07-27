# Secure Cloud Foundation

This repository contains the Terraform code for the following components of the Landing Zone:

## Azure Virtual Network

Azure Virtual Network is the fundamental building block for your private network in Azure. A virtual network enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks. A virtual network is similar to a traditional network that you'd operate in your own data center. An Azure Virtual Network brings with it extra benefits of Azure's infrastructure such as scale, availability, and isolation.

This Terraform module deploys a Virtual Network in Azure with a subnet or a set of subnets passed in as input parameters.
The module does not create nor expose a security group but it can associate Subnet with security group created. This would need to be defined separately as additional security rules on subnets in the deployed network.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_name"></a> [name](#module\_name) | ../_global/modules/naming | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_management_lock.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_virtual_network.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_config"></a> [client\_config](#input\_client\_config) | Data source to access the configurations of the Azurerm provider | `any` | `null` | no |
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | Global configurations for the Azure Landing Zone | `any` | `{}` | no |
| <a name="input_key"></a> [key](#input\_key) | Identifies the specific resource instance being deployed | `string` | `null` | no |
| <a name="input_network_security_groups"></a> [network\_security\_groups](#input\_network\_security\_groups) | Network Security Groups previously created and being referenced with an Instance key | `any` | `{}` | no |
| <a name="input_remote_states"></a> [remote\_states](#input\_remote\_states) | Outputs from the previous deployments that are stored in additional Terraform State Files | `any` | `{}` | no |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | Resource Groups previously created and being referenced with an Instance key | `any` | `{}` | no |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | Route Tables previously created and being referenced with an Instance key | `any` | `{}` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Provides the configuration values for the specific resources being deployed | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address_space"></a> [address\_space](#output\_address\_space) | The address space that is used the virtual network |
| <a name="output_id"></a> [id](#output\_id) | The virtual NetworkConfiguration ID |
| <a name="output_location"></a> [location](#output\_location) | The location/region where the virtual network is created |
| <a name="output_name"></a> [name](#output\_name) | The name of the virtual network |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group in which to create the virtual network |