terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_mssql_server" "this" {
  name                         = var.sql_server.name
  resource_group_name          = var.sql_server.resource_group_name
  location                     = var.sql_server.location
  version                      = var.sql_server.version
  administrator_login          = var.sql_server.administrator_login
  administrator_login_password = var.sql_server.administrator_login_password
  minimum_tls_version          = var.sql_server.minimum_tls_version
  public_network_access_enabled = var.sql_server.public_network_access_enabled
  outbound_network_access_restricted = var.sql_server.outbound_network_access_restricted
  connection_policy            = var.sql_server.connection_policy
  transparent_data_encryption_key_vault_key_id = var.sql_server.transparent_data_encryption_key_vault_key_id

  dynamic "azuread_administrator" {
    for_each = var.sql_server.azuread_administrator != null ? [var.sql_server.azuread_administrator] : []
    content {
      login_username              = azuread_administrator.value.login_username
      object_id                   = azuread_administrator.value.object_id
      tenant_id                   = azuread_administrator.value.tenant_id
      azuread_authentication_only = azuread_administrator.value.azuread_authentication_only
    }
  }

  dynamic "identity" {
    for_each = var.sql_server.identity != null ? [var.sql_server.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  tags = var.tags
}

resource "azurerm_mssql_database" "this" {
  for_each = var.sql_databases

  name                        = each.value.name
  server_id                   = azurerm_mssql_server.this.id
  collation                   = each.value.collation
  license_type                = each.value.license_type
  max_size_gb                 = each.value.max_size_gb
  read_scale                  = each.value.read_scale
  sku_name                    = each.value.sku_name
  zone_redundant              = each.value.zone_redundant
  auto_pause_delay_in_minutes = each.value.auto_pause_delay_in_minutes
  create_mode                 = each.value.create_mode
  creation_source_database_id = each.value.creation_source_database_id
  elastic_pool_id             = each.value.elastic_pool_id
  geo_backup_enabled          = each.value.geo_backup_enabled
  maintenance_configuration_name = each.value.maintenance_configuration_name
  ledger_enabled              = each.value.ledger_enabled
  min_capacity                = each.value.min_capacity
  restore_point_in_time       = each.value.restore_point_in_time
  recover_database_id         = each.value.recover_database_id
  restore_dropped_database_id = each.value.restore_dropped_database_id
  read_replica_count          = each.value.read_replica_count
  sample_name                 = each.value.sample_name
  storage_account_type        = each.value.storage_account_type
  transparent_data_encryption_enabled = each.value.transparent_data_encryption_enabled
  transparent_data_encryption_key_vault_key_id = each.value.transparent_data_encryption_key_vault_key_id
  transparent_data_encryption_key_automatic_rotation_enabled = each.value.transparent_data_encryption_key_automatic_rotation_enabled

  dynamic "threat_detection_policy" {
    for_each = each.value.threat_detection_policy != null ? [each.value.threat_detection_policy] : []
    content {
      state                      = threat_detection_policy.value.state
      disabled_alerts            = threat_detection_policy.value.disabled_alerts
      email_account_admins       = threat_detection_policy.value.email_account_admins
      email_addresses            = threat_detection_policy.value.email_addresses
      retention_days             = threat_detection_policy.value.retention_days
      storage_account_access_key = threat_detection_policy.value.storage_account_access_key
      storage_endpoint           = threat_detection_policy.value.storage_endpoint
    }
  }

  dynamic "short_term_retention_policy" {
    for_each = each.value.short_term_retention_policy != null ? [each.value.short_term_retention_policy] : []
    content {
      retention_days           = short_term_retention_policy.value.retention_days
      backup_interval_in_hours = short_term_retention_policy.value.backup_interval_in_hours
    }
  }

  dynamic "long_term_retention_policy" {
    for_each = each.value.long_term_retention_policy != null ? [each.value.long_term_retention_policy] : []
    content {
      weekly_retention  = long_term_retention_policy.value.weekly_retention
      monthly_retention = long_term_retention_policy.value.monthly_retention
      yearly_retention  = long_term_retention_policy.value.yearly_retention
      week_of_year      = long_term_retention_policy.value.week_of_year
    }
  }

  dynamic "import" {
    for_each = each.value.import != null ? [each.value.import] : []
    content {
      storage_uri                  = import.value.storage_uri
      storage_key                  = import.value.storage_key
      storage_key_type            = import.value.storage_key_type
      administrator_login         = import.value.administrator_login
      administrator_login_password = import.value.administrator_login_password
    }
  }

  tags = var.tags
}

resource "azurerm_mssql_firewall_rule" "this" {
  for_each = var.firewall_rules

  name             = each.value.name
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

resource "azurerm_mssql_virtual_network_rule" "this" {
  for_each = var.virtual_network_rules

  name      = each.value.name
  server_id = azurerm_mssql_server.this.id
  subnet_id = each.value.subnet_id
}

resource "azurerm_mssql_server_extended_auditing_policy" "this" {
  count = var.extended_auditing_policy != null ? 1 : 0

  server_id                               = azurerm_mssql_server.this.id
  enabled                                 = var.extended_auditing_policy.enabled
  storage_endpoint                        = var.extended_auditing_policy.storage_endpoint
  storage_account_access_key              = var.extended_auditing_policy.storage_account_access_key
  storage_account_access_key_is_secondary = var.extended_auditing_policy.storage_account_access_key_is_secondary
  retention_in_days                       = var.extended_auditing_policy.retention_in_days
  log_monitoring_enabled                  = var.extended_auditing_policy.log_monitoring_enabled
}

resource "azurerm_mssql_server_security_alert_policy" "this" {
  count = var.security_alert_policy != null ? 1 : 0

  resource_group_name        = var.sql_server.resource_group_name
  server_name                = azurerm_mssql_server.this.name
  state                      = var.security_alert_policy.state
  disabled_alerts            = var.security_alert_policy.disabled_alerts
  email_account_admins       = var.security_alert_policy.email_account_admins
  email_addresses            = var.security_alert_policy.email_addresses
  retention_days             = var.security_alert_policy.retention_days
  storage_account_access_key = var.security_alert_policy.storage_account_access_key
  storage_endpoint           = var.security_alert_policy.storage_endpoint
}

resource "azurerm_mssql_server_vulnerability_assessment" "this" {
  count = var.vulnerability_assessment != null ? 1 : 0

  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.this[0].id
  storage_container_path          = var.vulnerability_assessment.storage_container_path
  storage_account_access_key      = var.vulnerability_assessment.storage_account_access_key

  dynamic "recurring_scans" {
    for_each = var.vulnerability_assessment.recurring_scans != null ? [var.vulnerability_assessment.recurring_scans] : []
    content {
      enabled                   = recurring_scans.value.enabled
      email_subscription_admins = recurring_scans.value.email_subscription_admins
      emails                    = recurring_scans.value.emails
    }
  }
}

resource "azurerm_mssql_elastic_pool" "this" {
  for_each = var.elastic_pools

  name                = each.value.name
  resource_group_name = var.sql_server.resource_group_name
  location            = var.sql_server.location
  server_name         = azurerm_mssql_server.this.name
  license_type        = each.value.license_type
  max_size_gb         = each.value.max_size_gb
  zone_redundant      = each.value.zone_redundant
  maintenance_configuration_name = each.value.maintenance_configuration_name

  sku {
    name     = each.value.sku.name
    tier     = each.value.sku.tier
    family   = each.value.sku.family
    capacity = each.value.sku.capacity
  }

  per_database_settings {
    min_capacity = each.value.per_database_settings.min_capacity
    max_capacity = each.value.per_database_settings.max_capacity
  }

  tags = var.tags
} 