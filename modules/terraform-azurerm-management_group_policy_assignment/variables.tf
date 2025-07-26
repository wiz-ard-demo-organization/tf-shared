variable "key" {
  type        = string
  default     = null
  description = "Identifies the specific resource instance being deployed"
}

variable "global_settings" {
  type        = any
  default     = {}
  description = "Global configurations for the Azure Landing Zone"
}

variable "policy_assignment" {
  description = <<EOT
    policy_assignment = {
      name : "(Optional) The name of the policy assignment. Only lowercase alphanumeric characters and underscores allowed. If not provided, will use naming module result."
      display_name : "(Required) The display name of the policy assignment."
      description : "(Optional) The description of the policy assignment."
      policy_definition_id : "(Required) The ID of the Policy Definition or Policy Set Definition being assigned."
      management_group_id : "(Required) The ID of the Management Group where this policy should be assigned."
      parameters : "(Optional) The parameters for the policy assignment as JSON string. Conflicts with parameters_file_path."
      parameters_file_path : "(Optional) The path to a file containing the parameters for the policy assignment. Conflicts with parameters."
      enforce : "(Optional) Specifies whether the policy assignment is enforced. Defaults to true."
      location : "(Optional) The Azure Region where the Policy Assignment should exist. Required when an Identity is assigned."
      identity : "(Optional) Identity block for managed identity configuration."
      non_compliance_messages : "(Optional) List of non-compliance messages for better governance reporting."
      resource_selectors : "(Optional) List of resource selectors for targeted policy enforcement."
      overrides : "(Optional) List of overrides for fine-grained policy control."
    }
  EOT
  type = object({
    name                 = optional(string)
    display_name         = string
    description          = optional(string)
    policy_definition_id = string
    management_group_id  = string
    parameters           = optional(string)
    parameters_file_path = optional(string)
    enforce              = optional(bool, true)
    location             = optional(string)

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))

    non_compliance_messages = optional(list(object({
      content                        = string
      policy_definition_reference_id = optional(string)
    })))

    resource_selectors = optional(list(object({
      name = string
      selectors = list(object({
        kind   = string
        in     = optional(list(string))
        not_in = optional(list(string))
      }))
    })))

    overrides = optional(list(object({
      kind  = string
      value = string
      selectors = optional(list(object({
        kind   = string
        in     = optional(list(string))
        not_in = optional(list(string))
      })))
    })))
  })

  validation {
    condition = can(regex("^/.*", var.policy_assignment.policy_definition_id))
    error_message = "policy_definition_id must be a valid Azure resource ID starting with '/'."
  }

  validation {
    condition = !(var.policy_assignment.parameters != null && var.policy_assignment.parameters_file_path != null)
    error_message = "Cannot specify both parameters and parameters_file_path. Choose one."
  }

  validation {
    condition = var.policy_assignment.identity == null || var.policy_assignment.location != null
    error_message = "location must be specified when identity is configured."
  }

  validation {
    condition = var.policy_assignment.identity == null || contains(["SystemAssigned", "UserAssigned"], var.policy_assignment.identity.type)
    error_message = "identity.type must be either 'SystemAssigned' or 'UserAssigned'."
  }

  validation {
    condition = var.policy_assignment.identity == null || var.policy_assignment.identity.type != "UserAssigned" || var.policy_assignment.identity.identity_ids != null
    error_message = "identity_ids must be specified when identity.type is 'UserAssigned'."
  }

  validation {
    condition = var.policy_assignment.resource_selectors == null || alltrue([
      for rs in var.policy_assignment.resource_selectors : alltrue([
        for s in rs.selectors : contains(["resourceLocation", "resourceType", "resourceWithoutLocation"], s.kind)
      ])
    ])
    error_message = "resource_selector kind must be one of: 'resourceLocation', 'resourceType', or 'resourceWithoutLocation'."
  }

  validation {
    condition = var.policy_assignment.overrides == null || alltrue([
      for o in var.policy_assignment.overrides : contains(["policyEffect"], o.kind)
    ])
    error_message = "override kind must be 'policyEffect'."
  }
}
