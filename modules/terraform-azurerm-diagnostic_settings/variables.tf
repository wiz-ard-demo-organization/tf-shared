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

variable "diagnostic_setting" {
  description = <<EOT
    diagnostic_setting = {
      name : "(Required) Specifies the name of the Diagnostic Setting. Changing this forces a new resource to be created."
      target_resource_id : "(Required) The ID of an existing Resource on which to configure Diagnostic Settings. Changing this forces a new resource to be created."
      log_analytics_workspace_id : "(Optional) Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent."
      log_analytics_destination_type : "(Optional) When set to 'Dedicated' results in resource specific tables being created in the Log Analytics workspace, so each resource has a dedicated table. When set to 'AzureDiagnostics' results in all data being saved in the legacy AzureDiagnostics table."
      storage_account_id : "(Optional) The ID of the Storage Account where logs should be sent."
      eventhub_name : "(Optional) Specifies the name of the Event Hub where Diagnostics Data should be sent."
      eventhub_authorization_rule_id : "(Optional) Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data."
      partner_solution_id : "(Optional) The ID of the market partner solution where Diagnostics Data should be sent. For potential partner integrations, see documentation."
      enabled_log : (Optional) One or more enabled_log blocks. {
        category : "(Optional) The name of a Diagnostic Log Category for this Resource. When not set, all available logs are collected."
        category_group : "(Optional) The name of a Diagnostic Log Category Group for this Resource. When category_group is set, category cannot be set."
        retention_policy : (Optional) A retention_policy block. {
          enabled : "(Required) Is this Retention Policy enabled?"
          days : "(Optional) The number of days for which this Retention Policy should apply. Set to 0 for infinite retention."
        }
      }
      metric : (Optional) One or more metric blocks. {
        category : "(Required) The name of a Diagnostic Metric Category for this Resource."
        enabled : "(Optional) Is this Diagnostic Metric enabled? Defaults to true."
        retention_policy : (Optional) A retention_policy block. {
          enabled : "(Required) Is this Retention Policy enabled?"
          days : "(Optional) The number of days for which this Retention Policy should apply. Set to 0 for infinite retention."
        }
      }
    }
  EOT
  type = object({
    name                           = string
    target_resource_id             = string
    log_analytics_workspace_id     = optional(string)
    log_analytics_destination_type = optional(string)
    storage_account_id             = optional(string)
    eventhub_name                  = optional(string)
    eventhub_authorization_rule_id = optional(string)
    partner_solution_id            = optional(string)
    
    enabled_log = optional(list(object({
      category       = optional(string)
      category_group = optional(string)
      
      retention_policy = optional(object({
        enabled = bool
        days    = optional(number)
      }))
    })))
    
    metric = optional(list(object({
      category = string
      enabled  = optional(bool, true)
      
      retention_policy = optional(object({
        enabled = bool
        days    = optional(number)
      }))
    })))
  })

  validation {
    condition = (
      var.diagnostic_setting.log_analytics_workspace_id != null ||
      var.diagnostic_setting.storage_account_id != null ||
      (var.diagnostic_setting.eventhub_name != null && var.diagnostic_setting.eventhub_authorization_rule_id != null) ||
      var.diagnostic_setting.partner_solution_id != null
    )
    error_message = "At least one destination must be specified: Log Analytics, Storage Account, Event Hub, or Partner Solution."
  }

  validation {
    condition = alltrue([
      for log in coalesce(var.diagnostic_setting.enabled_log, []) : 
      log.category != null || log.category_group != null
    ])
    error_message = "Each enabled_log must specify either a category or category_group."
  }

  validation {
    condition = var.diagnostic_setting.log_analytics_destination_type == null || contains(["Dedicated", "AzureDiagnostics"], var.diagnostic_setting.log_analytics_destination_type)
    error_message = "log_analytics_destination_type must be either 'Dedicated' or 'AzureDiagnostics'."
  }
} 