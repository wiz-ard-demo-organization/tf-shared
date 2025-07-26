# Module for creating and managing Azure Management Group Policy Assignments to enforce policies at the management group level
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Generate standardized naming for the policy assignment using the global naming module
module "name" {
  source          = "../_global/modules/naming"
  key             = var.key
  global_settings = var.global_settings
  resource_type   = "azurerm_management_group_policy_assignment"
}

# Create Management Group Policy Assignment to enforce policies or policy sets at the management group scope
resource "azurerm_management_group_policy_assignment" "this" {
  name                 = try(var.policy_assignment.name, module.name.result)
  display_name         = var.policy_assignment.display_name
  description          = var.policy_assignment.description
  policy_definition_id = var.policy_assignment.policy_definition_id
  management_group_id  = "/providers/Microsoft.Management/ManagementGroups/${var.policy_assignment.management_group_id}"
  
  # Load parameters from external file if specified, otherwise use inline parameters
  parameters = var.policy_assignment.parameters_file_path != null ? file(var.policy_assignment.parameters_file_path) : var.policy_assignment.parameters
  
  # Enable or disable policy enforcement
  enforce = var.policy_assignment.enforce
  
  # Set location for policies that require it (e.g., for managed identity creation)
  location = var.policy_assignment.location

  # Configure managed identity for policy assignments that require elevated permissions
  dynamic "identity" {
    for_each = var.policy_assignment.identity != null ? [var.policy_assignment.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  # Configure non-compliance messages for better governance reporting
  dynamic "non_compliance_message" {
    for_each = var.policy_assignment.non_compliance_messages != null ? var.policy_assignment.non_compliance_messages : []
    content {
      content                        = non_compliance_message.value.content
      policy_definition_reference_id = non_compliance_message.value.policy_definition_reference_id
    }
  }

  # Configure resource selectors for targeted policy enforcement
  dynamic "resource_selector" {
    for_each = var.policy_assignment.resource_selectors != null ? var.policy_assignment.resource_selectors : []
    content {
      name = resource_selector.value.name
      
      dynamic "selector" {
        for_each = resource_selector.value.selectors
        content {
          kind   = selector.value.kind
          in     = selector.value.in
          not_in = selector.value.not_in
        }
      }
    }
  }

  # Configure overrides for fine-grained policy control
  dynamic "overrides" {
    for_each = var.policy_assignment.overrides != null ? var.policy_assignment.overrides : []
    content {
      value = overrides.value.value
      
      dynamic "selector" {
        for_each = overrides.value.selectors != null ? overrides.value.selectors : []
        content {
          in     = selector.value.in
          not_in = selector.value.not_in
        }
      }
    }
  }
}
