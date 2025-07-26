variable "storage_account" {
  description = "Configuration for the Azure Storage Account"
  type = object({
    name                              = string
    resource_group_name               = string
    location                          = string
    account_tier                      = string
    account_replication_type          = string
    account_kind                      = optional(string, "StorageV2")
    access_tier                       = optional(string, "Hot")
    cross_tenant_replication_enabled  = optional(bool, false)
    edge_zone                         = optional(string)
    enable_https_traffic_only         = optional(bool, true)
    min_tls_version                   = optional(string, "TLS1_2")
    allow_nested_items_to_be_public   = optional(bool, false)
    shared_access_key_enabled         = optional(bool, true)
    public_network_access_enabled     = optional(bool, true)
    default_to_oauth_authentication   = optional(bool, false)
    is_hns_enabled                    = optional(bool, false)
    nfsv3_enabled                     = optional(bool, false)
    large_file_share_enabled          = optional(bool, false)
    queue_encryption_key_type         = optional(string, "Service")
    table_encryption_key_type         = optional(string, "Service")
    infrastructure_encryption_enabled = optional(bool, false)
    sftp_enabled                      = optional(bool, false)
    dns_endpoint_type                 = optional(string, "Standard")

    custom_domain = optional(object({
      name          = string
      use_subdomain = optional(bool, false)
    }))

    customer_managed_key = optional(object({
      key_vault_key_id          = string
      user_assigned_identity_id = string
    }))

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))

    blob_properties = optional(object({
      versioning_enabled            = optional(bool, false)
      change_feed_enabled           = optional(bool, false)
      change_feed_retention_in_days = optional(number)
      default_service_version       = optional(string)
      last_access_time_enabled      = optional(bool, false)

      cors_rule = optional(list(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })))

      delete_retention_policy = optional(object({
        days = optional(number, 7)
      }))

      restore_policy = optional(object({
        days = number
      }))

      container_delete_retention_policy = optional(object({
        days = optional(number, 7)
      }))
    }))

    queue_properties = optional(object({
      cors_rule = optional(list(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })))

      logging = optional(object({
        delete                = bool
        read                  = bool
        version               = string
        write                 = bool
        retention_policy_days = optional(number)
      }))

      minute_metrics = optional(object({
        enabled               = bool
        version               = string
        include_apis          = optional(bool)
        retention_policy_days = optional(number)
      }))

      hour_metrics = optional(object({
        enabled               = bool
        version               = string
        include_apis          = optional(bool)
        retention_policy_days = optional(number)
      }))
    }))

    static_website = optional(object({
      index_document     = optional(string)
      error_404_document = optional(string)
    }))

    share_properties = optional(object({
      cors_rule = optional(list(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })))

      retention_policy = optional(object({
        days = optional(number, 7)
      }))

      smb = optional(object({
        versions                        = optional(set(string))
        authentication_types            = optional(set(string))
        kerberos_ticket_encryption_type = optional(set(string))
        channel_encryption_type         = optional(set(string))
        multichannel_enabled            = optional(bool, false)
      }))
    }))

    network_rules = optional(object({
      default_action             = string
      bypass                     = optional(set(string))
      ip_rules                   = optional(set(string))
      virtual_network_subnet_ids = optional(set(string))

      private_link_access = optional(list(object({
        endpoint_resource_id = string
        endpoint_tenant_id   = optional(string)
      })))
    }))

    azure_files_authentication = optional(object({
      directory_type = string

      active_directory = optional(object({
        domain_name         = string
        domain_guid         = string
        domain_sid          = optional(string)
        storage_sid         = optional(string)
        forest_name         = optional(string)
        netbios_domain_name = optional(string)
      }))
    }))

    routing = optional(object({
      publish_internet_endpoints  = optional(bool, false)
      publish_microsoft_endpoints = optional(bool, false)
      choice                      = optional(string, "MicrosoftRouting")
    }))

    immutability_policy = optional(object({
      allow_protected_append_writes = bool
      state                         = string
      period_since_creation_in_days = number
    }))

    sas_policy = optional(object({
      expiration_period = string
      expiration_action = optional(string, "Log")
    }))
  })

  validation {
    condition = contains(["Standard", "Premium"], var.storage_account.account_tier)
    error_message = "Account tier must be either 'Standard' or 'Premium'."
  }

  validation {
    condition = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_account.account_replication_type)
    error_message = "Invalid account replication type."
  }
}

variable "storage_containers" {
  description = "Map of storage containers to create"
  type = map(object({
    name                  = string
    container_access_type = optional(string, "private")
    metadata              = optional(map(string))
  }))
  default = {}

  validation {
    condition = alltrue([
      for container in var.storage_containers : contains(["blob", "container", "private"], container.container_access_type)
    ])
    error_message = "Container access type must be one of: 'blob', 'container', or 'private'."
  }
}

variable "lifecycle_management" {
  description = "Configuration for Storage Account lifecycle management policy"
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

  validation {
    condition = var.lifecycle_management == null || alltrue([
      for rule in var.lifecycle_management.rule : contains(["blockBlob"], rule.filters.blob_types...) || contains(["appendBlob"], rule.filters.blob_types...)
    ])
    error_message = "Blob types must include 'blockBlob' or 'appendBlob'."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
} 