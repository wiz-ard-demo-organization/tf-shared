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

variable "role_assignments" {
  description = <<EOT
    role_assignments = {
      scope : "(Required) The scope at which the Role Assignment applies to. This can be a subscription (e.g. /subscriptions/00000000-0000-0000-0000-000000000000), a resource group (e.g. /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup), or a resource (e.g. /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup/providers/Microsoft.Compute/virtualMachines/myVM). Changing this forces a new resource to be created."
      role_definition_name : "(Optional) The name of a built-in Role. Conflicts with role_definition_id. Changing this forces a new resource to be created."
      role_definition_id : "(Optional) The Scoped-ID of the Role Definition. Conflicts with role_definition_name. Changing this forces a new resource to be created."
      principal_id : "(Required) The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to. Changing this forces a new resource to be created."
      principal_type : "(Optional) The type of the principal_id. Possible values are User, Group and ServicePrincipal. It is necessary to explicitly set this attribute when creating role assignments if the principal creating the assignment is constrained by ABAC rules that filters on the PrincipalType attribute."
      condition : "(Optional) The condition that limits the resources that the role can be assigned to. Changing this forces a new resource to be created."
      condition_version : "(Optional) The version of the condition. Possible values are 1.0 or 2.0. Changing this forces a new resource to be created."
      description : "(Optional) The description for this Role Assignment. Changing this forces a new resource to be created."
      skip_service_principal_aad_check : "(Optional) If the principal_id is a newly provisioned Service Principal set this value to true to skip the Azure Active Directory check which may fail due to replication lag. This argument is only valid if the principal_id is a Service Principal identity. Defaults to false."
    }
  EOT
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
} 