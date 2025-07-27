# Module for creating and managing Azure Policy Set Definitions (Initiatives) to group multiple policy definitions for compliance frameworks
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Generate standardized naming for the policy set definition using the global naming module
module "name" {
  source          = "../_global/modules/naming"
  key             = var.key
  global_settings = var.global_settings
  resource_type   = "azurerm_policy_set_definition"
}

# Create Azure Policy Set Definition (Initiative) to group multiple policy definitions for governance and compliance frameworks
resource "azurerm_policy_set_definition" "this" {
  name                = try(var.settings.name, var.policy_set_definition.name, module.name.result)
  policy_type         = try(var.settings.policy_type, var.policy_set_definition.policy_type)
  display_name        = try(var.settings.display_name, var.policy_set_definition.display_name)
  description         = try(var.settings.description, var.policy_set_definition.description)
  management_group_id = try(var.settings.management_group_id, var.policy_set_definition.management_group_id) != null ? "/providers/Microsoft.Management/ManagementGroups/${try(var.settings.management_group_id, var.policy_set_definition.management_group_id)}" : null
  
  # Set metadata for the policy set definition, defaulting to standard regulatory compliance category
  metadata = try(var.settings.metadata, null) != null ? var.settings.metadata : try(var.policy_set_definition.metadata, null) != null ? var.policy_set_definition.metadata : jsonencode({
    category = try(var.settings.metadata_category, try(var.policy_set_definition.metadata_category, "Regulatory Compliance"))
  })

  # Load parameters from external file if specified, otherwise use inline parameters
  parameters = try(var.settings.parameters_file_path, null) != null ? file(var.settings.parameters_file_path) : try(var.policy_set_definition.parameters_file_path, null) != null ? file(var.policy_set_definition.parameters_file_path) : try(var.settings.parameters, try(var.policy_set_definition.parameters, null))

  # Create policy definition references for each policy in the initiative
  dynamic "policy_definition_reference" {
    for_each = try(var.settings.policy_definition_references, try(var.policy_set_definition.policy_definition_references, []))
    content {
      policy_definition_id = policy_definition_reference.value.policy_definition_id
      parameter_values     = try(policy_definition_reference.value.parameter_values, null) != null ? jsonencode(policy_definition_reference.value.parameter_values) : null
      reference_id         = try(policy_definition_reference.value.reference_id, null)
      policy_group_names   = try(policy_definition_reference.value.policy_group_names, null)
    }
  }

  # Create policy groups for organizing policies within the initiative
  dynamic "policy_definition_group" {
    for_each = try(var.settings.policy_definition_groups, try(var.policy_set_definition.policy_definition_groups, []))
    content {
      name                            = policy_definition_group.value.name
      display_name                    = try(policy_definition_group.value.display_name, null)
      category                        = try(policy_definition_group.value.category, null)
      description                     = try(policy_definition_group.value.description, null)
      additional_metadata_resource_id = try(policy_definition_group.value.additional_metadata_resource_id, null)
    }
  }
}
