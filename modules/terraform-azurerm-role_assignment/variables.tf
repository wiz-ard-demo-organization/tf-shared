variable "role_assignments" {
  description = "Map of role assignments to create"
  type = map(object({
    scope                            = string
    role_definition_name             = optional(string)
    role_definition_id               = optional(string)
    principal_id                     = string
    principal_type                   = optional(string)
    condition                        = optional(string)
    condition_version                = optional(string)
    description                      = optional(string)
    skip_service_principal_aad_check = optional(bool, false)
  }))

  validation {
    condition = alltrue([
      for ra in var.role_assignments : 
      ra.role_definition_name != null || ra.role_definition_id != null
    ])
    error_message = "Each role assignment must specify either role_definition_name or role_definition_id."
  }

  validation {
    condition = alltrue([
      for ra in var.role_assignments : 
      ra.principal_type == null || contains(["User", "Group", "ServicePrincipal", "ForeignGroup", "Device"], ra.principal_type)
    ])
    error_message = "principal_type must be one of: 'User', 'Group', 'ServicePrincipal', 'ForeignGroup', or 'Device'."
  }

  validation {
    condition = alltrue([
      for ra in var.role_assignments : 
      ra.condition_version == null || contains(["1.0", "2.0"], ra.condition_version)
    ])
    error_message = "condition_version must be either '1.0' or '2.0'."
  }

  validation {
    condition = alltrue([
      for ra in var.role_assignments : 
      (ra.condition != null && ra.condition_version != null) || (ra.condition == null && ra.condition_version == null)
    ])
    error_message = "Both condition and condition_version must be set together, or both must be null."
  }
} 