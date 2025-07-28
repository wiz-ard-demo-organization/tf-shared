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

variable "policy_definition" {
  description = <<EOT
    policy_definition = {
      name : "(Optional) The name of the policy definition. Only lowercase alphanumeric characters and underscores allowed. If not provided, will use naming module result."
      policy_type : "(Required) The policy type. Valid values are BuiltIn, Custom, NotSpecified and Static."
      mode : "(Required) The policy mode. Valid values are All, Indexed, Microsoft.KeyVault.Data, Microsoft.ContainerService.Data, Microsoft.Kubernetes.Data, Microsoft.Network.Data."
      display_name : "(Required) The display name of the policy definition."
      description : "(Optional) The description of the policy definition."
      management_group_id : "(Optional) The id of the Management Group where this policy should be defined. If not specified, policy will be created at subscription level."
      metadata : "(Optional) The metadata for the policy definition as JSON string. Conflicts with metadata_file_path."
      metadata_file_path : "(Optional) The path to a file containing the metadata for the policy definition. Conflicts with metadata."
      policy_rule : "(Optional) The policy rule as JSON string. Conflicts with policy_rule_file_path."
      policy_rule_file_path : "(Optional) The path to a file containing the policy rule. Conflicts with policy_rule."
      parameters : "(Optional) The parameters for the policy definition as JSON string. Conflicts with parameters_file_path."
      parameters_file_path : "(Optional) The path to a file containing the parameters for the policy definition. Conflicts with parameters."
    }
  EOT
  type = object({
    name                     = optional(string)
    policy_type              = string
    mode                     = string
    display_name             = string
    description              = optional(string)
    management_group_id      = optional(string)
    metadata                 = optional(string)
    metadata_file_path       = optional(string)
    policy_rule              = optional(string)
    policy_rule_file_path    = optional(string)
    parameters               = optional(string)
    parameters_file_path     = optional(string)
  })
}
