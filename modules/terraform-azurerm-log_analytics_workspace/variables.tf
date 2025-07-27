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

variable "log_analytics_workspace" {
  description = <<EOT
    log_analytics_workspace = {
      name : "(Required) Specifies the name of the Log Analytics Workspace. Workspace name should include 4-63 letters, digits or '-'. The '-' shouldn't be the first or the last symbol. Changing this forces a new resource to be created."
      location : "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
      resource_group_name : "(Required) The name of the resource group in which the Log Analytics workspace is created. Changing this forces a new resource to be created."
      sku : "(Required) Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03). Defaults to PerGB2018."
      retention_in_days : "(Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
      daily_quota_gb : "(Optional) The workspace daily quota for ingestion in GB. Defaults to -1 (unlimited) if omitted."
      internet_ingestion_enabled : "(Optional) Should the Log Analytics Workspace support ingestion over the Public Internet? Defaults to true."
      internet_query_enabled : "(Optional) Should the Log Analytics Workspace support querying over the Public Internet? Defaults to true."
      reservation_capacity_in_gb_per_day : "(Optional) The capacity reservation level in GB for this workspace. Possible values are 100, 200, 300, 400, 500, 1000, 2000 and 5000."
      data_collection_rule_id : "(Optional) The ID of the Data Collection Rule to use for this workspace."
      immediate_data_purge_on_30_days_enabled : "(Optional) Whether to remove the data in the Log Analytics Workspace immediately after 30 days. Defaults to false."
      cmk_for_query_forced : "(Optional) Is Customer Managed Storage mandatory for query management? Defaults to false."
      identity : (Optional) An identity block. {
        type : "(Required) Specifies the type of Managed Service Identity that should be configured on this Log Analytics Workspace. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned."
        identity_ids : "(Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Log Analytics Workspace."
      }
    }
  EOT
  type = object({
    name                       = string
    location                   = string
    resource_group_name        = string
    sku                        = string
    retention_in_days          = optional(number)
    daily_quota_gb             = optional(number)
    internet_ingestion_enabled = optional(bool, true)
    internet_query_enabled     = optional(bool, true)
    reservation_capacity_in_gb_per_day = optional(number)
    data_collection_rule_id    = optional(string)
    immediate_data_purge_on_30_days_enabled = optional(bool, false)
    cmk_for_query_forced       = optional(bool, false)

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
  })

  validation {
    condition = contains(["Free", "PerNode", "Premium", "Standard", "Standalone", "Unlimited", "CapacityReservation", "PerGB2018"], var.log_analytics_workspace.sku)
    error_message = "SKU must be one of: 'Free', 'PerNode', 'Premium', 'Standard', 'Standalone', 'Unlimited', 'CapacityReservation', or 'PerGB2018'."
  }

  validation {
    condition = var.log_analytics_workspace.retention_in_days == null || (var.log_analytics_workspace.retention_in_days >= 30 && var.log_analytics_workspace.retention_in_days <= 730)
    error_message = "Retention in days must be between 30 and 730 days."
  }

  validation {
    condition = var.log_analytics_workspace.daily_quota_gb == null || var.log_analytics_workspace.daily_quota_gb >= -1
    error_message = "Daily quota GB must be -1 (unlimited) or a positive number."
  }

  validation {
    condition = var.log_analytics_workspace.reservation_capacity_in_gb_per_day == null || contains([100, 200, 300, 400, 500, 1000, 2000, 5000], var.log_analytics_workspace.reservation_capacity_in_gb_per_day)
    error_message = "Reservation capacity must be one of: 100, 200, 300, 400, 500, 1000, 2000, or 5000 GB per day."
  }

  validation {
    condition = var.log_analytics_workspace.identity == null || contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.log_analytics_workspace.identity.type)
    error_message = "Identity type must be 'SystemAssigned', 'UserAssigned', or 'SystemAssigned, UserAssigned'."
  }
}











variable "tags" {
  description = "(Optional) A mapping of tags to assign to all resources created by this module."
  type        = map(string)
} 