variable "diagnostic_setting" {
  description = "Configuration for Azure Monitor Diagnostic Settings"
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