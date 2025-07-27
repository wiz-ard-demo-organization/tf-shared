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

variable "storage_account" {
  description = <<EOT
    storage_account = {
      name : "(Required) Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group."
      resource_group_name : "(Required) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created."
      location : "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
      account_tier : "(Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created."
      account_replication_type : "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS."
      account_kind : "(Optional) Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2."
      access_tier : "(Optional) Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
      cross_tenant_replication_enabled : "(Optional) Should cross Tenant replication be enabled? Defaults to false."
      edge_zone : "(Optional) Specifies the Edge Zone within the Azure Region where this Storage Account should exist. Changing this forces a new Storage Account to be created."
      min_tls_version : "(Optional) The minimum supported TLS version for the storage account. Possible values are TLS1_0, TLS1_1, and TLS1_2. Defaults to TLS1_2."
      allow_nested_items_to_be_public : "(Optional) Allow or disallow nested items within this Account to opt into being public. Defaults to false."
      shared_access_key_enabled : "(Optional) Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. Defaults to true."
      public_network_access_enabled : "(Optional) Whether the public network access is enabled? Defaults to true."
      default_to_oauth_authentication : "(Optional) Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account. Defaults to false."
      is_hns_enabled : "(Optional) Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2. Changing this forces a new resource to be created."
      nfsv3_enabled : "(Optional) Is NFSv3 protocol enabled? Changing this forces a new resource to be created. Defaults to false."
      large_file_share_enabled : "(Optional) Is Large File Share Enabled? Defaults to false."
      queue_encryption_key_type : "(Optional) The encryption type of the queue service. Possible values are Service and Account. Defaults to Service."
      table_encryption_key_type : "(Optional) The encryption type of the table service. Possible values are Service and Account. Defaults to Service."
      infrastructure_encryption_enabled : "(Optional) Is infrastructure encryption enabled? Changing this forces a new resource to be created. Defaults to false."
      sftp_enabled : "(Optional) Boolean, enable SFTP for the storage account. Defaults to false."
      dns_endpoint_type : "(Optional) Specifies which DNS endpoint type to use. Possible values are Standard and AzureDnsZone. Defaults to Standard."
      custom_domain : (Optional) A custom domain block. {
        name : "(Required) The Custom Domain Name to use for the Storage Account."
        use_subdomain : "(Optional) Should the Custom Domain Name be validated by using indirect CNAME validation?"
      }
      customer_managed_key : (Optional) A customer managed key block. {
        key_vault_key_id : "(Required) The ID of the Key Vault Key, supplying a version-less key ID will enable auto-rotation of this key."
        user_assigned_identity_id : "(Required) The ID of a user assigned identity."
      }
      identity : (Optional) An identity block. {
        type : "(Required) Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned."
        identity_ids : "(Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account."
      }
      blob_properties : (Optional) A blob_properties block. {
        versioning_enabled : "(Optional) Is versioning enabled? Defaults to false."
        change_feed_enabled : "(Optional) Is the blob service properties for change feed events enabled? Defaults to false."
        change_feed_retention_in_days : "(Optional) The duration of change feed events retention in days. Possible values are between 1 and 146000 days."
        default_service_version : "(Optional) The API Version which should be used by default for requests to the Data Plane API."
        last_access_time_enabled : "(Optional) Is the last access time based tracking enabled? Defaults to false."
        cors_rule : (Optional) A cors_rule block. {
          allowed_headers : "(Required) A list of headers that are allowed to be a part of the cross-origin request."
          allowed_methods : "(Required) A list of HTTP methods that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH."
          allowed_origins : "(Required) A list of origin domains that will be allowed by CORS."
          exposed_headers : "(Required) A list of response headers that are exposed to CORS clients."
          max_age_in_seconds : "(Required) The number of seconds the client should cache a preflight response."
        }
        delete_retention_policy : (Optional) A delete_retention_policy block. {
          days : "(Optional) Specifies the number of days that the blob should be retained, between 1 and 365 days. Defaults to 7."
        }
        restore_policy : (Optional) A restore_policy block. This must be used together with delete_retention_policy, versioning_enabled and change_feed_enabled. {
          days : "(Required) Specifies the number of days that the blob can be restored, between 1 and 365 days. This must be less than the days specified for delete_retention_policy."
        }
        container_delete_retention_policy : (Optional) A container_delete_retention_policy block. {
          days : "(Optional) Specifies the number of days that the container should be retained, between 1 and 365 days. Defaults to 7."
        }
      }
      queue_properties : (Optional) A queue_properties block. {
        cors_rule : (Optional) A cors_rule block with same structure as blob_properties.cors_rule.
        logging : (Optional) A logging block. {
          delete : "(Required) Indicates whether all delete requests should be logged."
          read : "(Required) Indicates whether all read requests should be logged."
          version : "(Required) The version of storage analytics to configure."
          write : "(Required) Indicates whether all write requests should be logged."
          retention_policy_days : "(Optional) Specifies the number of days that logs will be retained."
        }
        minute_metrics : (Optional) A minute_metrics block. {
          enabled : "(Required) Indicates whether minute metrics are enabled for the Queue service."
          version : "(Required) The version of storage analytics to configure."
          include_apis : "(Optional) Indicates whether metrics should generate summary statistics for called API operations."
          retention_policy_days : "(Optional) Specifies the number of days that logs will be retained."
        }
        hour_metrics : (Optional) An hour_metrics block with same structure as minute_metrics.
      }
      static_website : (Optional) A static_website block. {
        index_document : "(Optional) The webpage that Azure Storage serves for requests to the root of a website or any subfolder."
        error_404_document : "(Optional) The absolute path to a custom webpage that should be used when a request is made which does not correspond to an existing file."
      }
      share_properties : (Optional) A share_properties block. {
        cors_rule : (Optional) A cors_rule block with same structure as blob_properties.cors_rule.
        retention_policy : (Optional) A retention_policy block. {
          days : "(Optional) Specifies the number of days that the share should be retained, between 1 and 365 days. Defaults to 7."
        }
        smb : (Optional) A smb block. {
          versions : "(Optional) A set of SMB protocol versions. Possible values are SMB2.1, SMB3.0, and SMB3.1.1."
          authentication_types : "(Optional) A set of SMB authentication methods. Possible values are NTLMv2, and Kerberos."
          kerberos_ticket_encryption_type : "(Optional) A set of Kerberos ticket encryption types. Possible values are RC4-HMAC, and AES-256."
          channel_encryption_type : "(Optional) A set of SMB channel encryption. Possible values are AES-128-CCM, AES-128-GCM, and AES-256-GCM."
          multichannel_enabled : "(Optional) Indicates whether multichannel is enabled. Defaults to false."
        }
      }
      network_rules : (Optional) A network_rules block. {
        default_action : "(Required) The default action of allow or deny when no other rules match. Valid options are Deny or Allow."
        bypass : "(Optional) A list of resource types that should be bypassed for the Storage Account. Possible values are Logging, Metrics, AzureServices or None."
        ip_rules : "(Optional) List of public IP or IP ranges in CIDR Format."
        virtual_network_subnet_ids : "(Optional) A list of virtual network subnet ids to secure the storage account."
        private_link_access : (Optional) One or more private_link_access blocks. {
          endpoint_resource_id : "(Required) The ID of the Azure resource that should be allowed access to the Storage Account."
          endpoint_tenant_id : "(Optional) The tenant id of the Azure resource that should be allowed access to the Storage Account."
        }
      }
      azure_files_authentication : (Optional) An azure_files_authentication block. {
        directory_type : "(Required) Specifies the directory service used. Possible values are AADDS, AD and AADKERB."
        active_directory : (Optional) An active_directory block. Required when directory_type is AD. {
          domain_name : "(Required) Specifies the Primary domain that the AD DNS server is authoritative for."
          domain_guid : "(Required) Specifies the domain GUID."
          domain_sid : "(Optional) Specifies the security identifier (SID)."
          storage_sid : "(Optional) Specifies the security identifier (SID) for Azure Storage."
          forest_name : "(Optional) Specifies the Active Directory forest."
          netbios_domain_name : "(Optional) Specifies the NetBIOS domain name."
        }
      }
      routing : (Optional) A routing block. {
        publish_internet_endpoints : "(Optional) Should internet routing storage endpoints be published? Defaults to false."
        publish_microsoft_endpoints : "(Optional) Should Microsoft routing storage endpoints be published? Defaults to false."
        choice : "(Optional) Specifies the kind of network routing opted by the user. Possible values are InternetRouting and MicrosoftRouting. Defaults to MicrosoftRouting."
      }
      immutability_policy : (Optional) An immutability_policy block. {
        allow_protected_append_writes : "(Required) When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance."
        state : "(Required) Defines the mode of the policy. Disabled state disables the policy, Unlocked state allows increase and decrease of immutability retention time and also allows toggling allowProtectedAppendWrites property, Locked state only allows the increase of the immutability retention time."
        period_since_creation_in_days : "(Required) The immutability period for the blobs in the container since the policy creation, in days."
      }
      sas_policy : (Optional) A sas_policy block. {
        expiration_period : "(Required) The SAS expiration period in format of DD.HH:MM:SS."
        expiration_action : "(Optional) The SAS expiration action. The only possible value is Log at this moment. Defaults to Log."
      }
    }
  EOT
  type = object({
    name                              = optional(string)
    resource_group_name               = optional(string)
    location                          = optional(string)
    account_tier                      = optional(string)
    account_replication_type          = optional(string)
    account_kind                      = optional(string, "StorageV2")
    access_tier                       = optional(string, "Hot")
    cross_tenant_replication_enabled  = optional(bool, false)
    edge_zone                         = optional(string)
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
  default = null

  validation {
    condition = var.storage_account == null || contains(["Standard", "Premium"], var.storage_account.account_tier)
    error_message = "Account tier must be either 'Standard' or 'Premium'."
  }

  validation {
    condition = var.storage_account == null || contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_account.account_replication_type)
    error_message = "Invalid account replication type."
  }
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

  validation {
    condition = alltrue([
      for container in var.storage_containers : contains(["blob", "container", "private"], container.container_access_type)
    ])
    error_message = "Container access type must be one of: 'blob', 'container', or 'private'."
  }
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

  validation {
    condition = var.lifecycle_management == null || alltrue([
      for rule in var.lifecycle_management.rule : contains(["blockBlob"], rule.filters.blob_types...) || contains(["appendBlob"], rule.filters.blob_types...)
    ])
    error_message = "Blob types must include 'blockBlob' or 'appendBlob'."
  }
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to all resources created by this module."
  type        = map(string)
  default     = {}
} 