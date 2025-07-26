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
      local_authentication_disabled : "(Optional) Specifies if the Log Analytics Workspace should enforce authentication using Azure AD. Defaults to false."
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
  description = <<EOT
    log_analytics_solutions = {
      solution_name : "(Required) Specifies the name of the solution to be deployed. Changing this forces a new resource to be created."
      plan : (Required) A plan block. {
        publisher : "(Required) The publisher of the solution. For example Microsoft."
        product : "(Required) The product name of the solution. For example OMSGallery/Containers."
      }
    }
  EOT
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
  description = <<EOT
    data_export_rules = {
      name : "(Required) The name of the Data Export Rule. Changing this forces a new resource to be created."
      destination_resource_id : "(Required) The destination resource ID. This can be a Storage Account, an Event Hub Namespace or an Event Hub. Changing this forces a new resource to be created."
      table_names : "(Required) A list of table names to export to the destination resource. Changing this forces a new resource to be created."
      enabled : "(Optional) Is this data export rule enabled? Defaults to true."
    }
  EOT
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
  description = <<EOT
    saved_searches = {
      name : "(Required) The name of the Saved Search. Changing this forces a new resource to be created."
      category : "(Required) The category of the Saved Search."
      display_name : "(Required) The display name for this Saved Search."
      query : "(Required) The query expression for the saved search. Changing this forces a new resource to be created."
      function_alias : "(Optional) The function alias if the query serves as a function."
      function_parameters : "(Optional) The function parameters if the query serves as a function. Changing this forces a new resource to be created."
    }
  EOT
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
  description = <<EOT
    query_packs = {
      name : "(Required) The name which should be used for this Log Analytics Query Pack. Changing this forces a new resource to be created."
    }
  EOT
  type = map(object({
    name = string
  }))
  default = {}
}

variable "query_pack_queries" {
  description = <<EOT
    query_pack_queries = {
      query_pack_key : "(Required) The key reference to the query pack where this query should be added."
      body : "(Required) The body of the Query Pack Query. Changing this forces a new resource to be created."
      display_name : "(Required) The display name of the Query Pack Query."
      name : "(Required) The unique name of the Query Pack Query. Changing this forces a new resource to be created."
      description : "(Optional) The description of the Query Pack Query."
      categories : "(Optional) A list of categorization tags for the query."
      resource_types : "(Optional) A list of resource types that are applicable to this query."
      solutions : "(Optional) A list of solution names that are applicable to this query."
      tags : "(Optional) A mapping of tags which should be assigned to the Query Pack Query."
      additional_settings_json : "(Optional) Additional settings for the Query Pack Query in JSON format."
    }
  EOT
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
  description = "(Optional) A mapping of tags to assign to all resources created by this module."
  type        = map(string)
} 