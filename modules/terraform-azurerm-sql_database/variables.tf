variable "sql_server" {
  description = <<EOT
    sql_server = {
      name : "(Required) The name of the Microsoft SQL Server. This needs to be globally unique within Azure. Changing this forces a new resource to be created."
      resource_group_name : "(Required) The name of the resource group in which to create the Microsoft SQL Server. Changing this forces a new resource to be created."
      location : "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
      version : "(Optional) The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). Defaults to 12.0."
      administrator_login : "(Optional) The administrator login name for the new server. Required unless azuread_authentication_only in the azuread_administrator block is true."
      administrator_login_password : "(Optional) The password associated with the administrator_login user. Needs to comply with Azure's Password Policy."
      minimum_tls_version : "(Optional) The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server. Valid values are: 1.0, 1.1 and 1.2. Defaults to 1.2."
      public_network_access_enabled : "(Optional) Whether public network access is allowed for this server. Defaults to false."
      outbound_network_access_restricted : "(Optional) Whether outbound network traffic is restricted for this server. Defaults to false."
      connection_policy : "(Optional) The connection policy the server will use. Possible values are Default, Proxy, and Redirect. Defaults to Default."
      transparent_data_encryption_key_vault_key_id : "(Optional) The fully versioned Key Vault Key URL to be used as the Customer Managed Key for the Transparent Data Encryption layer."
      azuread_administrator : (Optional) An azuread_administrator block. {
        login_username : "(Required) The login username of the Azure AD Administrator of this SQL Server."
        object_id : "(Required) The object id of the Azure AD Administrator of this SQL Server."
        tenant_id : "(Optional) The tenant id of the Azure AD Administrator of this SQL Server."
        azuread_authentication_only : "(Optional) Specifies whether only AD Users and administrators can be used to login, or also local database users. Defaults to false."
      }
      identity : (Optional) An identity block. {
        type : "(Required) Specifies the type of Managed Service Identity that should be configured on this SQL Server. Possible values are SystemAssigned, UserAssigned."
        identity_ids : "(Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this SQL Server."
      }
    }
  EOT
  type = object({
    name                         = string
    resource_group_name          = string
    location                     = string
    version                      = optional(string, "12.0")
    administrator_login          = optional(string)
    administrator_login_password = optional(string)
    minimum_tls_version          = optional(string, "1.2")
    public_network_access_enabled = optional(bool, false)
    outbound_network_access_restricted = optional(bool, false)
    connection_policy            = optional(string, "Default")
    transparent_data_encryption_key_vault_key_id = optional(string)

    azuread_administrator = optional(object({
      login_username              = string
      object_id                   = string
      tenant_id                   = optional(string)
      azuread_authentication_only = optional(bool, false)
    }))

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
  })

  validation {
    condition = contains(["12.0"], var.sql_server.version)
    error_message = "SQL Server version must be '12.0'."
  }

  validation {
    condition = contains(["1.0", "1.1", "1.2"], var.sql_server.minimum_tls_version)
    error_message = "Minimum TLS version must be '1.0', '1.1', or '1.2'."
  }

  validation {
    condition = contains(["Default", "Proxy", "Redirect"], var.sql_server.connection_policy)
    error_message = "Connection policy must be 'Default', 'Proxy', or 'Redirect'."
  }

  validation {
    condition = (
      var.sql_server.administrator_login != null && var.sql_server.administrator_login_password != null
    ) || var.sql_server.azuread_administrator != null
    error_message = "Either SQL authentication (administrator_login and administrator_login_password) or Azure AD administrator must be configured."
  }

  validation {
    condition = var.sql_server.identity == null || contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.sql_server.identity.type)
    error_message = "Identity type must be 'SystemAssigned', 'UserAssigned', or 'SystemAssigned, UserAssigned'."
  }
}

variable "sql_databases" {
  description = "Map of SQL databases to create"
  type = map(object({
    name                        = string
    collation                   = optional(string, "SQL_Latin1_General_CP1_CI_AS")
    license_type                = optional(string)
    max_size_gb                 = optional(number)
    read_scale                  = optional(bool, false)
    sku_name                    = optional(string, "Basic")
    zone_redundant              = optional(bool, false)
    auto_pause_delay_in_minutes = optional(number)
    create_mode                 = optional(string, "Default")
    creation_source_database_id = optional(string)
    elastic_pool_id             = optional(string)
    geo_backup_enabled          = optional(bool, true)
    maintenance_configuration_name = optional(string)
    ledger_enabled              = optional(bool, false)
    min_capacity                = optional(number)
    restore_point_in_time       = optional(string)
    recover_database_id         = optional(string)
    restore_dropped_database_id = optional(string)
    read_replica_count          = optional(number)
    sample_name                 = optional(string)
    storage_account_type        = optional(string, "Geo")
    transparent_data_encryption_enabled = optional(bool, true)
    transparent_data_encryption_key_vault_key_id = optional(string)
    transparent_data_encryption_key_automatic_rotation_enabled = optional(bool, false)

    threat_detection_policy = optional(object({
      state                      = string
      disabled_alerts            = optional(set(string))
      email_account_admins       = optional(bool, false)
      email_addresses            = optional(set(string))
      retention_days             = optional(number)
      storage_account_access_key = optional(string)
      storage_endpoint           = optional(string)
    }))

    short_term_retention_policy = optional(object({
      retention_days           = number
      backup_interval_in_hours = optional(number)
    }))

    long_term_retention_policy = optional(object({
      weekly_retention  = optional(string)
      monthly_retention = optional(string)
      yearly_retention  = optional(string)
      week_of_year      = optional(number)
    }))

    import = optional(object({
      storage_uri                  = string
      storage_key                  = string
      storage_key_type            = string
      administrator_login         = string
      administrator_login_password = string
    }))
  }))
  default = {}

  validation {
    condition = alltrue([
      for db in var.sql_databases : contains(["Default", "Copy", "OnlineSecondary", "PointInTimeRestore", "Restore", "Recovery", "RestoreExternalBackup", "RestoreExternalBackupSecondary", "RestoreLongTermRetentionBackup", "Secondary"], db.create_mode)
    ])
    error_message = "Create mode must be a valid SQL Database create mode."
  }

  validation {
    condition = alltrue([
      for db in var.sql_databases : db.license_type == null || contains(["LicenseIncluded", "BasePrice"], db.license_type)
    ])
    error_message = "License type must be 'LicenseIncluded' or 'BasePrice'."
  }

  validation {
    condition = alltrue([
      for db in var.sql_databases : db.storage_account_type == null || contains(["Geo", "GeoZone", "Local", "Zone"], db.storage_account_type)
    ])
    error_message = "Storage account type must be 'Geo', 'GeoZone', 'Local', or 'Zone'."
  }

  validation {
    condition = alltrue([
      for db in var.sql_databases : db.sample_name == null || contains(["AdventureWorksLT", "WideWorldImportersStd", "WideWorldImportersFull"], db.sample_name)
    ])
    error_message = "Sample name must be 'AdventureWorksLT', 'WideWorldImportersStd', or 'WideWorldImportersFull'."
  }

  validation {
    condition = alltrue([
      for db in var.sql_databases : db.threat_detection_policy == null || contains(["Enabled", "Disabled"], db.threat_detection_policy.state)
    ])
    error_message = "Threat detection policy state must be 'Enabled' or 'Disabled'."
  }

  validation {
    condition = alltrue([
      for db in var.sql_databases : db.short_term_retention_policy == null || (db.short_term_retention_policy.retention_days >= 1 && db.short_term_retention_policy.retention_days <= 35)
    ])
    error_message = "Short term retention policy retention days must be between 1 and 35."
  }

  validation {
    condition = alltrue([
      for db in var.sql_databases : db.import == null || contains(["StorageAccessKey", "SharedAccessKey"], db.import.storage_key_type)
    ])
    error_message = "Import storage key type must be 'StorageAccessKey' or 'SharedAccessKey'."
  }
}

variable "firewall_rules" {
  description = "Map of firewall rules for the SQL server"
  type = map(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  default = {}

  validation {
    condition = alltrue([
      for rule in var.firewall_rules : can(cidrhost("${rule.start_ip_address}/32", 0)) && can(cidrhost("${rule.end_ip_address}/32", 0))
    ])
    error_message = "Start and end IP addresses must be valid IP addresses."
  }
}

variable "virtual_network_rules" {
  description = "Map of virtual network rules for the SQL server"
  type = map(object({
    name      = string
    subnet_id = string
  }))
  default = {}
}

variable "extended_auditing_policy" {
  description = "Extended auditing policy configuration for the SQL server"
  type = object({
    enabled                                 = bool
    storage_endpoint                        = optional(string)
    storage_account_access_key              = optional(string)
    storage_account_access_key_is_secondary = optional(bool, false)
    retention_in_days                       = optional(number)
    log_monitoring_enabled                  = optional(bool, false)
  })
  default = null

  validation {
    condition = var.extended_auditing_policy == null || (var.extended_auditing_policy.enabled == false || (var.extended_auditing_policy.storage_endpoint != null && var.extended_auditing_policy.storage_account_access_key != null))
    error_message = "When extended auditing is enabled, storage_endpoint and storage_account_access_key must be provided."
  }

  validation {
    condition = var.extended_auditing_policy == null || var.extended_auditing_policy.retention_in_days == null || (var.extended_auditing_policy.retention_in_days >= 0 && var.extended_auditing_policy.retention_in_days <= 3285)
    error_message = "Retention in days must be between 0 and 3285."
  }
}

variable "security_alert_policy" {
  description = "Security alert policy configuration for the SQL server"
  type = object({
    state                      = string
    disabled_alerts            = optional(set(string))
    email_account_admins       = optional(bool, false)
    email_addresses            = optional(set(string))
    retention_days             = optional(number)
    storage_account_access_key = optional(string)
    storage_endpoint           = optional(string)
  })
  default = null

  validation {
    condition = var.security_alert_policy == null || contains(["Enabled", "Disabled"], var.security_alert_policy.state)
    error_message = "Security alert policy state must be 'Enabled' or 'Disabled'."
  }

  validation {
    condition = var.security_alert_policy == null || var.security_alert_policy.disabled_alerts == null || alltrue([
      for alert in var.security_alert_policy.disabled_alerts : contains([
        "Sql_Injection",
        "Sql_Injection_Vulnerability",
        "Access_Anomaly",
        "Data_Exfiltration",
        "Unsafe_Action",
        "Brute_Force"
      ], alert)
    ])
    error_message = "Disabled alerts must be valid alert types."
  }
}

variable "vulnerability_assessment" {
  description = "Vulnerability assessment configuration for the SQL server"
  type = object({
    storage_container_path     = string
    storage_account_access_key = string

    recurring_scans = optional(object({
      enabled                   = bool
      email_subscription_admins = optional(bool, false)
      emails                    = optional(set(string))
    }))
  })
  default = null
}

variable "elastic_pools" {
  description = "Map of elastic pools to create"
  type = map(object({
    name                = string
    license_type        = optional(string)
    max_size_gb         = optional(number)
    zone_redundant      = optional(bool, false)
    maintenance_configuration_name = optional(string)

    sku = object({
      name     = string
      tier     = string
      family   = optional(string)
      capacity = number
    })

    per_database_settings = object({
      min_capacity = number
      max_capacity = number
    })
  }))
  default = {}

  validation {
    condition = alltrue([
      for pool in var.elastic_pools : pool.license_type == null || contains(["LicenseIncluded", "BasePrice"], pool.license_type)
    ])
    error_message = "Elastic pool license type must be 'LicenseIncluded' or 'BasePrice'."
  }

  validation {
    condition = alltrue([
      for pool in var.elastic_pools : contains(["BasicPool", "StandardPool", "PremiumPool", "GP_Gen4", "GP_Gen5", "GP_Fsv2", "GP_DC", "BC_Gen4", "BC_Gen5", "BC_M"], pool.sku.name)
    ])
    error_message = "Elastic pool SKU name must be a valid elastic pool SKU."
  }

  validation {
    condition = alltrue([
      for pool in var.elastic_pools : contains(["Basic", "Standard", "Premium", "GeneralPurpose", "BusinessCritical"], pool.sku.tier)
    ])
    error_message = "Elastic pool SKU tier must be a valid tier."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
} 