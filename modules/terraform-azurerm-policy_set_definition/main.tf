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
  name                = try(var.policy_set_definition.name, module.name.result)
  policy_type         = var.policy_set_definition.policy_type
  display_name        = var.policy_set_definition.display_name
  description         = var.policy_set_definition.description
  management_group_id = var.policy_set_definition.management_group_id != null ? "/providers/Microsoft.Management/ManagementGroups/${var.policy_set_definition.management_group_id}" : null
  
  # Set metadata for the policy set definition, defaulting to standard regulatory compliance category
  metadata = var.policy_set_definition.metadata != null ? var.policy_set_definition.metadata : jsonencode({
    category = var.policy_set_definition.metadata_category
  })

  # Load parameters from external file if specified, otherwise use inline parameters
  parameters = var.policy_set_definition.parameters_file_path != null ? file(var.policy_set_definition.parameters_file_path) : var.policy_set_definition.parameters

  # Create policy definition references for each policy in the initiative
  dynamic "policy_definition_reference" {
    for_each = var.policy_set_definition.policy_definition_references
    content {
      policy_definition_id = policy_definition_reference.value.policy_definition_id
      parameter_values     = policy_definition_reference.value.parameter_values != null ? jsonencode(policy_definition_reference.value.parameter_values) : null
      reference_id         = policy_definition_reference.value.reference_id
      policy_group_names   = policy_definition_reference.value.policy_group_names
    }
  }

  # Create policy groups for organizing policies within the initiative
  dynamic "policy_definition_group" {
    for_each = var.policy_set_definition.policy_definition_groups != null ? var.policy_set_definition.policy_definition_groups : []
    content {
      name                            = policy_definition_group.value.name
      display_name                    = policy_definition_group.value.display_name
      category                        = policy_definition_group.value.category
      description                     = policy_definition_group.value.description
      additional_metadata_resource_id = policy_definition_group.value.additional_metadata_resource_id
    }
  }
}
