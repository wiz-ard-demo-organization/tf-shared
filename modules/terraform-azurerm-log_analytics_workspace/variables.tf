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
  description = "Configuration for the Log Analytics Workspace"
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
    local_authentication_disabled = optional(bool, false)
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

variable "log_analytics_solutions" {
  description = "Map of Log Analytics solutions to deploy"
  type = map(object({
    solution_name = string
    plan = object({
      publisher = string
      product   = string
    })
  }))
  default = {}

  validation {
    condition = alltrue([
      for solution in var.log_analytics_solutions : contains([
        "AgentHealthAssessment",
        "AntiMalware", 
        "ApplicationInsights",
        "AzureActivity",
        "AzureAutomation",
        "AzureNSGAnalytics",
        "AzureSQLAnalytics",
        "ChangeTracking",
        "Containers",
        "KeyVault",
        "LogicAppsManagement",
        "NetworkMonitoring",
        "Security",
        "SecurityCenterFree",
        "ServiceMap",
        "SQLAssessment",
        "Updates",
        "VMInsights"
      ], solution.solution_name)
    ])
    error_message = "Invalid solution name. Must be a valid Azure Log Analytics solution."
  }
}

variable "data_export_rules" {
  description = "Map of data export rules for the Log Analytics workspace"
  type = map(object({
    name                    = string
    destination_resource_id = string
    table_names             = list(string)
    enabled                 = optional(bool, true)
  }))
  default = {}

  validation {
    condition = alltrue([
      for rule in var.data_export_rules : length(rule.table_names) > 0
    ])
    error_message = "Each data export rule must specify at least one table name."
  }
}

variable "saved_searches" {
  description = "Map of saved searches for the Log Analytics workspace"
  type = map(object({
    name                = string
    category            = string
    display_name        = string
    query               = string
    function_alias      = optional(string)
    function_parameters = optional(list(string))
  }))
  default = {}

  validation {
    condition = alltrue([
      for search in var.saved_searches : length(search.query) > 0
    ])
    error_message = "Each saved search must have a non-empty query."
  }
}

variable "query_packs" {
  description = "Map of query packs to create"
  type = map(object({
    name = string
  }))
  default = {}
}

variable "query_pack_queries" {
  description = "Map of queries to add to query packs"
  type = map(object({
    query_pack_key           = string
    body                     = string
    display_name             = string
    name                     = string
    description              = optional(string)
    categories               = optional(list(string))
    resource_types           = optional(list(string))
    solutions                = optional(list(string))
    tags                     = optional(map(string))
    additional_settings_json = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for query in var.query_pack_queries : length(query.body) > 0
    ])
    error_message = "Each query pack query must have a non-empty body."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
} 