# Module for creating and managing Azure Storage Accounts with comprehensive configuration options including blob properties, lifecycle management, and network security rules
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Create the main Azure Storage Account with specified configuration for blob, file, queue, and table services
resource "azurerm_storage_account" "this" {
  name                              = var.storage_account.name
  resource_group_name               = var.storage_account.resource_group_name
  location                          = var.storage_account.location
  account_tier                      = var.storage_account.account_tier
  account_replication_type          = var.storage_account.account_replication_type
  account_kind                      = var.storage_account.account_kind
  access_tier                       = var.storage_account.access_tier
  cross_tenant_replication_enabled  = var.storage_account.cross_tenant_replication_enabled
  edge_zone                         = var.storage_account.edge_zone
  enable_https_traffic_only         = var.storage_account.enable_https_traffic_only
  min_tls_version                   = var.storage_account.min_tls_version
  allow_nested_items_to_be_public   = var.storage_account.allow_nested_items_to_be_public
  shared_access_key_enabled         = var.storage_account.shared_access_key_enabled
  public_network_access_enabled     = var.storage_account.public_network_access_enabled
  default_to_oauth_authentication   = var.storage_account.default_to_oauth_authentication
  is_hns_enabled                    = var.storage_account.is_hns_enabled
  nfsv3_enabled                     = var.storage_account.nfsv3_enabled
  large_file_share_enabled          = var.storage_account.large_file_share_enabled
  queue_encryption_key_type         = var.storage_account.queue_encryption_key_type
  table_encryption_key_type         = var.storage_account.table_encryption_key_type
  infrastructure_encryption_enabled = var.storage_account.infrastructure_encryption_enabled
  sftp_enabled                      = var.storage_account.sftp_enabled
  dns_endpoint_type                 = var.storage_account.dns_endpoint_type

  # Configure custom domain for storage account endpoints
  dynamic "custom_domain" {
    for_each = var.storage_account.custom_domain != null ? [var.storage_account.custom_domain] : []
    content {
      name          = custom_domain.value.name
      use_subdomain = custom_domain.value.use_subdomain
    }
  }

  # Configure customer-managed encryption keys for enhanced security
  dynamic "customer_managed_key" {
    for_each = var.storage_account.customer_managed_key != null ? [var.storage_account.customer_managed_key] : []
    content {
      key_vault_key_id          = customer_managed_key.value.key_vault_key_id
      user_assigned_identity_id = customer_managed_key.value.user_assigned_identity_id
    }
  }

  # Configure managed identity for the storage account
  dynamic "identity" {
    for_each = var.storage_account.identity != null ? [var.storage_account.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  # Configure blob service properties including versioning, change feed, and lifecycle policies
  dynamic "blob_properties" {
    for_each = var.storage_account.blob_properties != null ? [var.storage_account.blob_properties] : []
    content {
      versioning_enabled       = blob_properties.value.versioning_enabled
      change_feed_enabled      = blob_properties.value.change_feed_enabled
      change_feed_retention_in_days = blob_properties.value.change_feed_retention_in_days
      default_service_version  = blob_properties.value.default_service_version
      last_access_time_enabled = blob_properties.value.last_access_time_enabled

      # Configure CORS rules for blob service
      dynamic "cors_rule" {
        for_each = blob_properties.value.cors_rule != null ? blob_properties.value.cors_rule : []
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      # Configure soft delete retention policy for blobs
      dynamic "delete_retention_policy" {
        for_each = blob_properties.value.delete_retention_policy != null ? [blob_properties.value.delete_retention_policy] : []
        content {
          days = delete_retention_policy.value.days
        }
      }

      # Configure point-in-time restore capability
      dynamic "restore_policy" {
        for_each = blob_properties.value.restore_policy != null ? [blob_properties.value.restore_policy] : []
        content {
          days = restore_policy.value.days
        }
      }

      # Configure soft delete retention policy for containers
      dynamic "container_delete_retention_policy" {
        for_each = blob_properties.value.container_delete_retention_policy != null ? [blob_properties.value.container_delete_retention_policy] : []
        content {
          days = container_delete_retention_policy.value.days
        }
      }
    }
  }

  # Configure queue service properties including logging and metrics
  dynamic "queue_properties" {
    for_each = var.storage_account.queue_properties != null ? [var.storage_account.queue_properties] : []
    content {
      # Configure CORS rules for queue service
      dynamic "cors_rule" {
        for_each = queue_properties.value.cors_rule != null ? queue_properties.value.cors_rule : []
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      # Configure logging for queue operations
      dynamic "logging" {
        for_each = queue_properties.value.logging != null ? [queue_properties.value.logging] : []
        content {
          delete                = logging.value.delete
          read                  = logging.value.read
          version               = logging.value.version
          write                 = logging.value.write
          retention_policy_days = logging.value.retention_policy_days
        }
      }

      # Configure minute-level metrics for queue service
      dynamic "minute_metrics" {
        for_each = queue_properties.value.minute_metrics != null ? [queue_properties.value.minute_metrics] : []
        content {
          enabled               = minute_metrics.value.enabled
          version               = minute_metrics.value.version
          include_apis          = minute_metrics.value.include_apis
          retention_policy_days = minute_metrics.value.retention_policy_days
        }
      }

      # Configure hour-level metrics for queue service
      dynamic "hour_metrics" {
        for_each = queue_properties.value.hour_metrics != null ? [queue_properties.value.hour_metrics] : []
        content {
          enabled               = hour_metrics.value.enabled
          version               = hour_metrics.value.version
          include_apis          = hour_metrics.value.include_apis
          retention_policy_days = hour_metrics.value.retention_policy_days
        }
      }
    }
  }

  # Configure static website hosting capabilities
  dynamic "static_website" {
    for_each = var.storage_account.static_website != null ? [var.storage_account.static_website] : []
    content {
      index_document     = static_website.value.index_document
      error_404_document = static_website.value.error_404_document
    }
  }

  # Configure file share properties including SMB settings
  dynamic "share_properties" {
    for_each = var.storage_account.share_properties != null ? [var.storage_account.share_properties] : []
    content {
      # Configure CORS rules for file service
      dynamic "cors_rule" {
        for_each = share_properties.value.cors_rule != null ? share_properties.value.cors_rule : []
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      # Configure soft delete retention policy for file shares
      dynamic "retention_policy" {
        for_each = share_properties.value.retention_policy != null ? [share_properties.value.retention_policy] : []
        content {
          days = retention_policy.value.days
        }
      }

      # Configure SMB protocol settings for file shares
      dynamic "smb" {
        for_each = share_properties.value.smb != null ? [share_properties.value.smb] : []
        content {
          versions                        = smb.value.versions
          authentication_types            = smb.value.authentication_types
          kerberos_ticket_encryption_type = smb.value.kerberos_ticket_encryption_type
          channel_encryption_type         = smb.value.channel_encryption_type
          multichannel_enabled            = smb.value.multichannel_enabled
        }
      }
    }
  }

  # Configure network access rules and firewall settings
  dynamic "network_rules" {
    for_each = var.storage_account.network_rules != null ? [var.storage_account.network_rules] : []
    content {
      default_action             = network_rules.value.default_action
      bypass                     = network_rules.value.bypass
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids

      # Configure private endpoint connections
      dynamic "private_link_access" {
        for_each = network_rules.value.private_link_access != null ? network_rules.value.private_link_access : []
        content {
          endpoint_resource_id = private_link_access.value.endpoint_resource_id
          endpoint_tenant_id   = private_link_access.value.endpoint_tenant_id
        }
      }
    }
  }

  # Configure Azure Files authentication with Active Directory
  dynamic "azure_files_authentication" {
    for_each = var.storage_account.azure_files_authentication != null ? [var.storage_account.azure_files_authentication] : []
    content {
      directory_type = azure_files_authentication.value.directory_type

      # Configure on-premises Active Directory integration
      dynamic "active_directory" {
        for_each = azure_files_authentication.value.active_directory != null ? [azure_files_authentication.value.active_directory] : []
        content {
          domain_name         = active_directory.value.domain_name
          domain_guid         = active_directory.value.domain_guid
          domain_sid          = active_directory.value.domain_sid
          storage_sid         = active_directory.value.storage_sid
          forest_name         = active_directory.value.forest_name
          netbios_domain_name = active_directory.value.netbios_domain_name
        }
      }
    }
  }

  # Configure routing preferences for data traffic
  dynamic "routing" {
    for_each = var.storage_account.routing != null ? [var.storage_account.routing] : []
    content {
      publish_internet_endpoints  = routing.value.publish_internet_endpoints
      publish_microsoft_endpoints = routing.value.publish_microsoft_endpoints
      choice                      = routing.value.choice
    }
  }

  # Configure immutability policy for compliance requirements
  dynamic "immutability_policy" {
    for_each = var.storage_account.immutability_policy != null ? [var.storage_account.immutability_policy] : []
    content {
      allow_protected_append_writes = immutability_policy.value.allow_protected_append_writes
      state                         = immutability_policy.value.state
      period_since_creation_in_days = immutability_policy.value.period_since_creation_in_days
    }
  }

  # Configure SAS token policy settings
  dynamic "sas_policy" {
    for_each = var.storage_account.sas_policy != null ? [var.storage_account.sas_policy] : []
    content {
      expiration_period = sas_policy.value.expiration_period
      expiration_action = sas_policy.value.expiration_action
    }
  }

  tags = var.tags
}

# Storage Containers - Create blob containers within the storage account
resource "azurerm_storage_container" "this" {
  for_each = var.storage_containers

  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = each.value.container_access_type
  metadata              = each.value.metadata
}

# Storage Management Policy - Configure lifecycle management rules for automatic blob tiering and deletion
resource "azurerm_storage_management_policy" "this" {
  count = var.lifecycle_management != null ? 1 : 0

  storage_account_id = azurerm_storage_account.this.id

  dynamic "rule" {
    for_each = var.lifecycle_management.rule
    content {
      name    = rule.value.name
      enabled = rule.value.enabled

      # Define filters to target specific blobs
      filters {
        prefix_match = rule.value.filters.prefix_match
        blob_types   = rule.value.filters.blob_types

        # Match blobs based on index tags
        dynamic "match_blob_index_tag" {
          for_each = rule.value.filters.match_blob_index_tag != null ? rule.value.filters.match_blob_index_tag : []
          content {
            name      = match_blob_index_tag.value.name
            operation = match_blob_index_tag.value.operation
            value     = match_blob_index_tag.value.value
          }
        }
      }

      # Define actions to perform on matched blobs
      actions {
        # Actions for base blobs
        dynamic "base_blob" {
          for_each = rule.value.actions.base_blob != null ? [rule.value.actions.base_blob] : []
          content {
            tier_to_cool_after_days_since_modification_greater_than        = base_blob.value.tier_to_cool_after_days_since_modification_greater_than
            tier_to_archive_after_days_since_modification_greater_than     = base_blob.value.tier_to_archive_after_days_since_modification_greater_than
            delete_after_days_since_modification_greater_than              = base_blob.value.delete_after_days_since_modification_greater_than
            tier_to_cool_after_days_since_last_access_time_greater_than    = base_blob.value.tier_to_cool_after_days_since_last_access_time_greater_than
            tier_to_archive_after_days_since_last_access_time_greater_than = base_blob.value.tier_to_archive_after_days_since_last_access_time_greater_than
            delete_after_days_since_last_access_time_greater_than          = base_blob.value.delete_after_days_since_last_access_time_greater_than
            auto_tier_to_hot_from_cool_enabled                             = base_blob.value.auto_tier_to_hot_from_cool_enabled
          }
        }

        # Actions for blob snapshots
        dynamic "snapshot" {
          for_each = rule.value.actions.snapshot != null ? [rule.value.actions.snapshot] : []
          content {
            change_tier_to_archive_after_days_since_creation = snapshot.value.change_tier_to_archive_after_days_since_creation
            change_tier_to_cool_after_days_since_creation    = snapshot.value.change_tier_to_cool_after_days_since_creation
            delete_after_days_since_creation_greater_than    = snapshot.value.delete_after_days_since_creation_greater_than
          }
        }

        # Actions for blob versions
        dynamic "version" {
          for_each = rule.value.actions.version != null ? [rule.value.actions.version] : []
          content {
            change_tier_to_archive_after_days_since_creation = version.value.change_tier_to_archive_after_days_since_creation
            change_tier_to_cool_after_days_since_creation    = version.value.change_tier_to_cool_after_days_since_creation
            delete_after_days_since_creation                 = version.value.delete_after_days_since_creation
          }
        }
      }
    }
  }
} 