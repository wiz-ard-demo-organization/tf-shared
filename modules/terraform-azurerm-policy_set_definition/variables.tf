variable "key" {
  type        = string
  default     = null
  description = "Identifies the specific resource instance being deployed"
}

variable "settings" {
  type        = any
  default     = {}
  description = "Provides the configuration values for the specific resources being deployed"
}

variable "global_settings" {
  type        = any
  default     = {}
  description = "Global configurations for the Azure Landing Zone"
}

variable "client_config" {
  type        = any
  default     = null
  description = "Data source to access the configurations of the Azurerm provider"
}

variable "remote_states" {
  type        = any
  default     = {}
  description = "Outputs from the previous deployments that are stored in additional Terraform State Files"
}

variable "policy_set_definition" {
  description = <<EOT
    policy_set_definition = {
      name : "(Optional) The name of the policy set definition. Only lowercase alphanumeric characters and underscores allowed. If not provided, will use naming module result."
      policy_type : "(Required) The policy type. Valid values are BuiltIn, Custom, NotSpecified and Static."
      display_name : "(Required) The display name of the policy set definition."
      description : "(Optional) The description of the policy set definition."
      management_group_id : "(Optional) The id of the Management Group where this policy set should be defined. If not specified, policy set will be created at subscription level."
      metadata : "(Optional) The metadata for the policy set definition as JSON string. If not provided, will use metadata_category."
      metadata_category : "(Optional) The category for the metadata. Defaults to 'Regulatory Compliance'."
      parameters : "(Optional) The parameters for the policy set definition as JSON string. Conflicts with parameters_file_path."
      parameters_file_path : "(Optional) The path to a file containing the parameters for the policy set definition. Conflicts with parameters."
      policy_definition_references : "(Required) List of policy definition references for this initiative."
      policy_definition_groups : "(Optional) List of policy definition groups for organizing policies within the initiative."
    }
  EOT
  type = object({
    name                         = optional(string)
    policy_type                  = string
    display_name                 = string
    description                  = optional(string)
    management_group_id          = optional(string)
    metadata                     = optional(string)
    metadata_category            = optional(string, "Regulatory Compliance")
    parameters                   = optional(string)
    parameters_file_path         = optional(string)
    
    policy_definition_references = list(object({
      policy_definition_id = string
      parameter_values     = optional(map(any))
      reference_id         = optional(string)
      policy_group_names   = optional(list(string))
    }))

    policy_definition_groups = optional(list(object({
      name                            = string
      display_name                    = optional(string)
      category                        = optional(string)
      description                     = optional(string)
      additional_metadata_resource_id = optional(string)
    })))
  })
  default = null

  validation {
    condition = var.policy_set_definition == null || contains(["BuiltIn", "Custom", "NotSpecified", "Static"], var.policy_set_definition.policy_type)
    error_message = "Policy type must be one of: 'BuiltIn', 'Custom', 'NotSpecified', or 'Static'."
  }

  validation {
    condition = var.policy_set_definition == null || !(var.policy_set_definition.parameters != null && var.policy_set_definition.parameters_file_path != null)
    error_message = "Cannot specify both parameters and parameters_file_path. Choose one."
  }

  validation {
    condition = var.policy_set_definition == null || length(var.policy_set_definition.policy_definition_references) > 0
    error_message = "At least one policy definition reference must be specified."
  }

  validation {
    condition = var.policy_set_definition == null || alltrue([
      for ref in var.policy_set_definition.policy_definition_references : 
      can(regex("^/.*", ref.policy_definition_id))
    ])
    error_message = "All policy_definition_id values must be valid Azure resource IDs starting with '/'."
  }
}
