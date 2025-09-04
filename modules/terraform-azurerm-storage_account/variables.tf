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


variable "storage_containers" {
  description = <<EOT
    storage_containers = {
      name : "(Required) The name of the Container which should be created within the Storage Account. Changing this forces a new resource to be created."
      container_access_type : "(Optional) The Access Level configured for this Container. Possible values are blob, container or private. Defaults to private."
      metadata : "(Optional) A mapping of MetaData for this Container. All metadata keys should be lowercase."
    }
  EOT
  type = map(object({
    name                  = string
    container_access_type = optional(string, "private")
    metadata              = optional(map(string))
  }))
  default = {}
}

variable "lifecycle_management" {
  description = <<EOT
    lifecycle_management = {
      rule : (Required) One or more rule blocks. {
        name : "(Required) The name of the rule. Rule name is case-sensitive. It must be unique within a policy."
        enabled : "(Required) Boolean to specify whether the rule is enabled."
        filters : (Required) A filters block. {
          prefix_match : "(Optional) An array of strings for prefixes to be matched."
          blob_types : "(Required) An array of predefined values. Valid options are blockBlob and appendBlob."
          match_blob_index_tag : (Optional) A match_blob_index_tag block. {
            name : "(Required) The name of the blob index tag."
            operation : "(Optional) The comparison operator which is used for object comparison and filtering. Possible value is ==. Defaults to ==."
            value : "(Required) The value of the blob index tag."
          }
        }
        actions : (Required) An actions block. {
          base_blob : (Optional) A base_blob block. {
            tier_to_cool_after_days_since_modification_greater_than : "(Optional) The age in days after last modification to tier blobs to cool storage."
            tier_to_archive_after_days_since_modification_greater_than : "(Optional) The age in days after last modification to tier blobs to archive storage."
            delete_after_days_since_modification_greater_than : "(Optional) The age in days after last modification to delete the blob."
            tier_to_cool_after_days_since_last_access_time_greater_than : "(Optional) The age in days after last access time to tier blobs to cool storage."
            tier_to_archive_after_days_since_last_access_time_greater_than : "(Optional) The age in days after last access time to tier blobs to archive storage."
            delete_after_days_since_last_access_time_greater_than : "(Optional) The age in days after last access time to delete the blob."
            auto_tier_to_hot_from_cool_enabled : "(Optional) Whether to auto-tier blobs from cool to hot storage based on access patterns. Defaults to false."
          }
          snapshot : (Optional) A snapshot block. {
            change_tier_to_archive_after_days_since_creation : "(Optional) The age in days after creation to tier blob snapshots to archive storage."
            change_tier_to_cool_after_days_since_creation : "(Optional) The age in days after creation to tier blob snapshots to cool storage."
            delete_after_days_since_creation_greater_than : "(Optional) The age in days after creation to delete blob snapshots."
          }
          version : (Optional) A version block. {
            change_tier_to_archive_after_days_since_creation : "(Optional) The age in days after creation to tier blob versions to archive storage."
            change_tier_to_cool_after_days_since_creation : "(Optional) The age in days after creation to tier blob versions to cool storage."
            delete_after_days_since_creation : "(Optional) The age in days after creation to delete blob versions."
          }
        }
      }
    }
  EOT
  type = object({
    rule = list(object({
      name    = string
      enabled = bool

      filters = object({
        prefix_match = optional(set(string))
        blob_types   = set(string)

        match_blob_index_tag = optional(list(object({
          name      = string
          operation = optional(string, "==")
          value     = string
        })))
      })

      actions = object({
        base_blob = optional(object({
          tier_to_cool_after_days_since_modification_greater_than        = optional(number)
          tier_to_archive_after_days_since_modification_greater_than     = optional(number)
          delete_after_days_since_modification_greater_than              = optional(number)
          tier_to_cool_after_days_since_last_access_time_greater_than    = optional(number)
          tier_to_archive_after_days_since_last_access_time_greater_than = optional(number)
          delete_after_days_since_last_access_time_greater_than          = optional(number)
          auto_tier_to_hot_from_cool_enabled                             = optional(bool, false)
        }))

        snapshot = optional(object({
          change_tier_to_archive_after_days_since_creation = optional(number)
          change_tier_to_cool_after_days_since_creation    = optional(number)
          delete_after_days_since_creation_greater_than    = optional(number)
        }))

        version = optional(object({
          change_tier_to_archive_after_days_since_creation = optional(number)
          change_tier_to_cool_after_days_since_creation    = optional(number)
          delete_after_days_since_creation                 = optional(number)
        }))
      })
    }))
  })
  default = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to all resources created by this module."
  type        = map(string)
  default     = {}
} 