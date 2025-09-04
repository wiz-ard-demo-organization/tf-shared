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
  name                 = try(var.settings.name, module.name.result)
  display_name         = try(var.settings.display_name, null)
  description          = try(var.settings.description, null)
  policy_definition_id = try(var.settings.policy_definition_id, null)
  management_group_id  = "/providers/Microsoft.Management/ManagementGroups/${var.settings.management_group_id}"
  
  # Load parameters from external file if specified, otherwise use inline parameters
  parameters = try(var.settings.parameters_file_path, null) != null ? file(var.settings.parameters_file_path) : try(var.settings.parameters, null)
  
  # Enable or disable policy enforcement
  enforce = try(var.settings.enforce, true)
  
  # Set location for policies that require it (e.g., for managed identity creation)
  location = try(var.settings.location, null)

  # Configure managed identity for policy assignments that require elevated permissions
  dynamic "identity" {
    for_each = try(var.settings.identity, null) != null ? [var.settings.identity] : []
    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, null)
    }
  }

  # Configure non-compliance messages for better governance reporting
  dynamic "non_compliance_message" {
    for_each = try(var.settings.non_compliance_messages, [])
    content {
      content                        = non_compliance_message.value.content
      policy_definition_reference_id = try(non_compliance_message.value.policy_definition_reference_id, null)
    }
  }

  # Configure resource selectors for targeted policy enforcement
  dynamic "resource_selectors" {
    for_each = try(var.settings.resource_selectors, [])
    content {
      name = try(resource_selectors.value.name, null)
      
      dynamic "selectors" {
        for_each = resource_selectors.value.selectors
        content {
          kind   = selectors.value.kind
          in     = try(selectors.value.in, null)
          not_in = try(selectors.value.not_in, null)
        }
      }
    }
  }

  # Configure overrides for fine-grained policy control
  dynamic "overrides" {
    for_each = try(var.settings.overrides, [])
    content {
      value = overrides.value.value
      
      dynamic "selectors" {
        for_each = try(overrides.value.selectors, [])
        content {
          in     = try(selectors.value.in, null)
          not_in = try(selectors.value.not_in, null)
        }
      }
    }
  }
}
