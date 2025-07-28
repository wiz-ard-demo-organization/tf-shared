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

variable "resource_groups" {
  type        = any
  default     = {}
  description = "Resource Groups previously created and being referenced with an Instance key"
}

variable "container_registry" {
  description = <<EOT
    container_registry = {
      name : "(Required) Specifies the name of the Container Registry. Only Alphanumeric characters allowed. Changing this forces a new resource to be created."
      resource_group_name : "(Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created."
      location : "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
      sku : "(Required) The SKU name of the container registry. Possible values are Basic, Standard and Premium."
      admin_enabled : "(Optional) Specifies whether the admin user is enabled. Defaults to false."
      public_network_access_enabled : "(Optional) Whether public network access is allowed for the container registry. Defaults to true."
             quarantine_policy_enabled : "(Optional) Boolean value that indicates whether quarantine policy is enabled. Only supported on Premium SKU."
      zone_redundancy_enabled : "(Optional) Whether zone redundancy is enabled for this Container Registry. Changing this forces a new resource to be created. Defaults to false. Only supported on Premium SKU."
      export_policy_enabled : "(Optional) Boolean value that indicates whether export policy is enabled. Defaults to true. Only supported on Premium SKU."
      anonymous_pull_enabled : "(Optional) Whether to allow anonymous (unauthenticated) pull access to this Container Registry. Only supported on Standard or Premium SKU."
      data_endpoint_enabled : "(Optional) Whether to enable dedicated data endpoints for this Container Registry. Only supported on Premium SKU."
      network_rule_bypass_option : "(Optional) Whether to allow trusted Azure services to access a network-restricted Container Registry. Possible values are None and AzureServices. Defaults to AzureServices."
      georeplications : (Optional) One or more georeplications blocks. Only supported on Premium SKU. {
        location : "(Required) A location where the container registry should be geo-replicated."
        regional_endpoint_enabled : "(Optional) Whether regional endpoint is enabled for this Container Registry."
        zone_redundancy_enabled : "(Optional) Whether zone redundancy is enabled for this replication location. Defaults to false."
        tags : "(Optional) A mapping of tags to assign to this replication location."
      }
      network_rule_set : (Optional) A network_rule_set block. Only supported on Premium SKU. {
        default_action : "(Optional) The behaviour for requests matching no rules. Either Allow or Deny. Defaults to Allow."
        ip_rule : (Optional) One or more ip_rule blocks. {
          action : "(Required) The behaviour for requests matching this rule. At this time the only supported value is Allow."
          ip_range : "(Required) The CIDR block from which requests will match the rule."
        }
      }
      identity : (Optional) An identity block. {
        type : "(Required) Specifies the type of Managed Service Identity that should be configured on this Container Registry. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned."
        identity_ids : "(Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Container Registry."
      }
      encryption : (Optional) An encryption block. Only supported on Premium SKU. {
        key_vault_key_id : "(Required) The ID of the Key Vault Key, supplying a version-less key ID will enable auto-rotation of this key."
        identity_client_id : "(Required) The client ID of the managed identity associated with the encryption key."
      }
    }
  EOT
  type = object({
    name                          = optional(string)
    resource_group_name           = optional(string)
    location                      = optional(string)
    sku                           = string
    admin_enabled                 = optional(bool)
    public_network_access_enabled = optional(bool)
         quarantine_policy_enabled     = optional(bool)
    zone_redundancy_enabled       = optional(bool)
    export_policy_enabled         = optional(bool)
    anonymous_pull_enabled        = optional(bool)
    data_endpoint_enabled         = optional(bool)
    network_rule_bypass_option    = optional(string)

    georeplications = optional(list(object({
      location                  = string
      regional_endpoint_enabled = optional(bool)
      zone_redundancy_enabled   = optional(bool)
      tags                      = optional(map(string))
    })))

    network_rule_set = optional(object({
      default_action = optional(string)
      ip_rule = optional(list(object({
        action   = string
        ip_range = string
      })))
    }))

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))

    encryption = optional(object({
      key_vault_key_id   = string
      identity_client_id = string
    }))
  })
  default = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the Container Registry."
  type        = map(string)
  default     = {}
} 