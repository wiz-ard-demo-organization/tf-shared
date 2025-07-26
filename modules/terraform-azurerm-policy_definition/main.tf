# Module for creating and managing Azure Policy Definitions with metadata, policy rules, and parameters for governance and compliance
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Generate standardized naming for the policy definition using the global naming module
module "name" {
  source          = "../_global/modules/naming"
  key             = var.key
  global_settings = var.global_settings
  resource_type   = "azurerm_policy_definition"
}

# Create Azure Policy Definition with custom policy rules and parameters for governance requirements
resource "azurerm_policy_definition" "this" {
  name                = try(var.policy_definition.name, module.name.result)
  policy_type         = var.policy_definition.policy_type
  mode                = var.policy_definition.mode
  display_name        = var.policy_definition.display_name
  description         = var.policy_definition.description
  management_group_id = var.policy_definition.management_group_id != null ? "/providers/Microsoft.Management/ManagementGroups/${var.policy_definition.management_group_id}" : null

  # Load policy metadata from external file if specified
  metadata = var.policy_definition.metadata_file_path != null ? file(var.policy_definition.metadata_file_path) : var.policy_definition.metadata

  # Load policy rules from external file if specified  
  policy_rule = var.policy_definition.policy_rule_file_path != null ? file(var.policy_definition.policy_rule_file_path) : var.policy_definition.policy_rule

  # Load policy parameters from external file if specified
  parameters = var.policy_definition.parameters_file_path != null ? file(var.policy_definition.parameters_file_path) : var.policy_definition.parameters
}
