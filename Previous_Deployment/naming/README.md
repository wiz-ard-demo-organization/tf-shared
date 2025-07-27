# Secure Cloud Foundation

This repository contains the Terraform code for the following components of the Landing Zone:

## Naming Convention
Naming Convention generates the "Service Name" based on the Resource Type, Workload/Project, Environment, Region, Instance Version, Additional Description etc

| Resource Type | Workload/Project | Additional Description |   Environment    |         Region          | Instance Version |
| :-----------: | :--------------: | :--------------------: | :--------------: | :---------------------: | :--------------: |
|      rg       |       plat       |          lvl0          | Production(prod) | South Central US (scus) |      "001"       |

This Module generates the Service Name for Resource Group as "rg-plat-lvl0-prod-scus-001" if provided with the above inputs.

The **Resource Type** is taken from the resource_types.tf in the naming module.  
The **Workload/Project** will be generated from application_code global variable which will be specified in .yml variables.  
**Additional Description** is taken from the key that was created while provisioning resources.  
**Environment** will be generated from environment_code global variable which will be specified in .yml variables.  
**Region** will be taken from the location_code global setting variable stored in .yml variables.  
The **version** can be specified as a part of the key or by default it will be "001".  

## Inputs

| Name                                                                              | Description                                                                               | Type     | Default | Required |
| --------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | -------- | ------- | :------: |
| <a name="input_client_config"></a> [client\_config](#input\_client\_config)       | Data source to access the configurations of the Azurerm provider                          | `any`    | `null`  |    no    |
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | Global configurations for the Azure Landing Zone                                          | `any`    | `{}`    |    no    |
| <a name="input_key"></a> [key](#input\_key)                                       | Identifies the specific resource instance being deployed                                  | `string` | `null`  |    no    |
| <a name="input_remote_states"></a> [remote\_states](#input\_remote\_states)       | Outputs from the previous deployments that are stored in additional Terraform State Files | `any`    | `{}`    |    no    |
| <a name="input_resource_type"></a> [resource\_type](#input\_resource\_type)       | Type of Azure Service being used                                                          | `any`    | n/a     |   yes    |
| <a name="input_settings"></a> [settings](#input\_settings)                        | Provides the configuration values for the specific resources being deployed               | `any`    | `{}`    |    no    |

## Outputs

| Name                                                   | Description                              |
| ------------------------------------------------------ | ---------------------------------------- |
| <a name="output_result"></a> [result](#output\_result) | Specifies the name of the Named Resource |
