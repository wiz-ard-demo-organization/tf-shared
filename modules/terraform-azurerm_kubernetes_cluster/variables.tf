variable "kubernetes_cluster" {
  description = "Configuration for the Azure Kubernetes Service cluster"
  type = object({
    name                                = string
    location                            = string
    resource_group_name                 = string
    dns_prefix                          = optional(string)
    dns_prefix_private_cluster          = optional(string)
    kubernetes_version                  = optional(string)
    sku_tier                            = optional(string, "Free")
    api_server_authorized_ip_ranges     = optional(set(string))
    node_resource_group                 = optional(string)
    disk_encryption_set_id              = optional(string)
    private_cluster_enabled             = optional(bool, false)
    private_dns_zone_id                 = optional(string)
    private_cluster_public_fqdn_enabled = optional(bool, false)
    public_network_access_enabled       = optional(bool, true)
    role_based_access_control_enabled   = optional(bool, true)
    local_account_disabled              = optional(bool, false)
    automatic_channel_upgrade           = optional(string)
    azure_policy_enabled                = optional(bool, false)
    workload_identity_enabled           = optional(bool, false)
    oidc_issuer_enabled                 = optional(bool, false)
    image_cleaner_enabled               = optional(bool, false)
    image_cleaner_interval_hours        = optional(number)
    cost_analysis_enabled               = optional(bool, false)
    run_command_enabled                 = optional(bool, true)
    support_plan                        = optional(string)
    node_os_channel_upgrade             = optional(string)

    default_node_pool = object({
      name                         = string
      node_count                   = optional(number)
      vm_size                      = string
      vnet_subnet_id               = optional(string)
      zones                        = optional(set(string))
      enable_auto_scaling          = optional(bool, false)
      min_count                    = optional(number)
      max_count                    = optional(number)
      max_pods                     = optional(number)
      os_disk_size_gb              = optional(number)
      os_disk_type                 = optional(string, "Managed")
      ultra_ssd_enabled            = optional(bool, false)
      node_public_ip_enabled       = optional(bool, false)
      node_public_ip_prefix_id     = optional(string)
      enable_host_encryption       = optional(bool, false)
      enable_node_public_ip        = optional(bool, false)
      kubelet_disk_type            = optional(string)
      temporary_name_for_rotation  = optional(string)
      type                         = optional(string, "VirtualMachineScaleSets")
      orchestrator_version         = optional(string)
      proximity_placement_group_id = optional(string)
      workload_runtime             = optional(string)
      only_critical_addons_enabled = optional(bool, false)
      pod_subnet_id                = optional(string)
      scale_down_mode              = optional(string, "Delete")
      snapshot_id                  = optional(string)
      host_group_id                = optional(string)
      capacity_reservation_group_id = optional(string)
      fips_enabled                 = optional(bool, false)
      gpu_instance_profile         = optional(string)
      message_of_the_day           = optional(string)
      node_labels                  = optional(map(string))
      node_taints                  = optional(list(string))

      kubelet_config = optional(object({
        allowed_unsafe_sysctls    = optional(list(string))
        container_log_max_line    = optional(number)
        container_log_max_size_mb = optional(number)
        cpu_cfs_quota_enabled     = optional(bool)
        cpu_cfs_quota_period      = optional(string)
        cpu_manager_policy        = optional(string)
        image_gc_high_threshold   = optional(number)
        image_gc_low_threshold    = optional(number)
        pod_max_pid               = optional(number)
        topology_manager_policy   = optional(string)
      }))

      linux_os_config = optional(object({
        swap_file_size_mb             = optional(number)
        transparent_huge_page_enabled = optional(string)
        transparent_huge_page_defrag  = optional(string)

        sysctl_config = optional(object({
          fs_aio_max_nr                      = optional(number)
          fs_file_max                        = optional(number)
          fs_inotify_max_user_watches        = optional(number)
          fs_nr_open                         = optional(number)
          kernel_threads_max                 = optional(number)
          net_core_netdev_max_backlog        = optional(number)
          net_core_optmem_max                = optional(number)
          net_core_rmem_default              = optional(number)
          net_core_rmem_max                  = optional(number)
          net_core_somaxconn                 = optional(number)
          net_core_wmem_default              = optional(number)
          net_core_wmem_max                  = optional(number)
          net_ipv4_ip_local_port_range_max   = optional(number)
          net_ipv4_ip_local_port_range_min   = optional(number)
          net_ipv4_neigh_default_gc_thresh1  = optional(number)
          net_ipv4_neigh_default_gc_thresh2  = optional(number)
          net_ipv4_neigh_default_gc_thresh3  = optional(number)
          net_ipv4_tcp_fin_timeout           = optional(number)
          net_ipv4_tcp_keepalive_intvl       = optional(number)
          net_ipv4_tcp_keepalive_probes      = optional(number)
          net_ipv4_tcp_keepalive_time        = optional(number)
          net_ipv4_tcp_max_syn_backlog       = optional(number)
          net_ipv4_tcp_max_tw_buckets        = optional(number)
          net_ipv4_tcp_tw_reuse              = optional(bool)
          net_netfilter_nf_conntrack_buckets = optional(number)
          net_netfilter_nf_conntrack_max     = optional(number)
          vm_max_map_count                   = optional(number)
          vm_swappiness                      = optional(number)
          vm_vfs_cache_pressure              = optional(number)
        }))
      }))

      node_network_profile = optional(object({
        application_security_group_ids = optional(list(string))
        node_public_ip_tags           = optional(map(string))
      }))

      upgrade_settings = optional(object({
        drain_timeout_in_minutes      = optional(number)
        node_soak_duration_in_minutes = optional(number)
        max_surge                     = string
      }))
    })

    network_profile = optional(object({
      network_plugin      = string
      network_mode        = optional(string)
      network_policy      = optional(string)
      dns_service_ip      = optional(string)
      outbound_type       = optional(string, "loadBalancer")
      pod_cidr            = optional(string)
      pod_cidrs           = optional(list(string))
      service_cidr        = optional(string)
      service_cidrs       = optional(list(string))
      ip_versions         = optional(list(string))
      load_balancer_sku   = optional(string, "standard")
      network_plugin_mode = optional(string)
      network_data_plane  = optional(string)
      ebpf_data_plane     = optional(string)

      load_balancer_profile = optional(object({
        idle_timeout_in_minutes     = optional(number)
        managed_outbound_ip_count   = optional(number)
        managed_outbound_ipv6_count = optional(number)
        outbound_ip_address_ids     = optional(set(string))
        outbound_ip_prefix_ids      = optional(set(string))
        outbound_ports_allocated    = optional(number)
      }))

      nat_gateway_profile = optional(object({
        idle_timeout_in_minutes   = optional(number)
        managed_outbound_ip_count = optional(number)
      }))
    }))

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))

    service_principal = optional(object({
      client_id     = string
      client_secret = string
    }))

    auto_scaler_profile = optional(object({
      balance_similar_node_groups      = optional(bool)
      expander                         = optional(string)
      max_graceful_termination_sec     = optional(string)
      max_node_provisioning_time       = optional(string)
      max_unready_nodes                = optional(number)
      max_unready_percentage           = optional(number)
      new_pod_scale_up_delay           = optional(string)
      scale_down_delay_after_add       = optional(string)
      scale_down_delay_after_delete    = optional(string)
      scale_down_delay_after_failure   = optional(string)
      scan_interval                    = optional(string)
      scale_down_unneeded              = optional(string)
      scale_down_unready               = optional(string)
      scale_down_utilization_threshold = optional(string)
      empty_bulk_delete_max            = optional(string)
      skip_nodes_with_local_storage    = optional(bool)
      skip_nodes_with_system_pods      = optional(bool)
    }))

    api_server_access_profile = optional(object({
      authorized_ip_ranges     = optional(set(string))
      vnet_integration_enabled = optional(bool, false)
      subnet_id                = optional(string)
    }))

    azure_active_directory_role_based_access_control = optional(object({
      managed                = optional(bool, true)
      tenant_id              = optional(string)
      admin_group_object_ids = optional(list(string))
      azure_rbac_enabled     = optional(bool, false)
    }))

    http_proxy_config = optional(object({
      http_proxy  = optional(string)
      https_proxy = optional(string)
      no_proxy    = optional(list(string))
      trusted_ca  = optional(string)
    }))

    oms_agent = optional(object({
      log_analytics_workspace_id      = string
      msi_auth_for_monitoring_enabled = optional(bool, false)
    }))

    ingress_application_gateway = optional(object({
      gateway_id   = optional(string)
      gateway_name = optional(string)
      subnet_cidr  = optional(string)
      subnet_id    = optional(string)
    }))

    key_vault_secrets_provider = optional(object({
      secret_rotation_enabled  = optional(bool, false)
      secret_rotation_interval = optional(string, "2m")
    }))

    linux_profile = optional(object({
      admin_username = string
      ssh_key = object({
        key_data = string
      })
    }))

    windows_profile = optional(object({
      admin_username = string
      admin_password = optional(string)
      license        = optional(string)

      gmsa = optional(object({
        dns_server  = string
        root_domain = string
      }))
    }))

    maintenance_window = optional(object({
      allowed = optional(list(object({
        day   = string
        hours = set(number)
      })))

      not_allowed = optional(list(object({
        end   = string
        start = string
      })))
    }))

    maintenance_window_auto_upgrade = optional(object({
      frequency    = string
      interval     = number
      duration     = number
      day_of_week  = optional(string)
      day_of_month = optional(number)
      week_index   = optional(string)
      start_time   = optional(string)
      utc_offset   = optional(string)
      start_date   = optional(string)

      not_allowed = optional(list(object({
        end   = string
        start = string
      })))
    }))

    maintenance_window_node_os = optional(object({
      frequency    = string
      interval     = number
      duration     = number
      day_of_week  = optional(string)
      day_of_month = optional(number)
      week_index   = optional(string)
      start_time   = optional(string)
      utc_offset   = optional(string)
      start_date   = optional(string)

      not_allowed = optional(list(object({
        end   = string
        start = string
      })))
    }))

    microsoft_defender = optional(object({
      log_analytics_workspace_id = string
    }))

    monitor_metrics = optional(object({
      annotations_allowed = optional(string)
      labels_allowed      = optional(string)
    }))

    storage_profile = optional(object({
      blob_driver_enabled         = optional(bool, false)
      disk_driver_enabled         = optional(bool, true)
      disk_driver_version         = optional(string, "v1")
      file_driver_enabled         = optional(bool, true)
      snapshot_controller_enabled = optional(bool, true)
    }))

    web_app_routing = optional(object({
      dns_zone_id = optional(string)
      dns_zone_ids = optional(list(string))
      web_app_routing_identity = optional(list(object({
        client_id                       = string
        object_id                       = string
        user_assigned_identity_id       = string
      })))
    }))

    workload_autoscaler_profile = optional(object({
      keda_enabled                    = optional(bool, false)
      vertical_pod_autoscaler_enabled = optional(bool, false)
    }))

    service_mesh_profile = optional(object({
      mode                             = string
      internal_ingress_gateway_enabled = optional(bool, false)
      external_ingress_gateway_enabled = optional(bool, false)
    }))
  })

  validation {
    condition = var.kubernetes_cluster.dns_prefix != null || var.kubernetes_cluster.dns_prefix_private_cluster != null
    error_message = "Either dns_prefix or dns_prefix_private_cluster must be specified."
  }

  validation {
    condition = var.kubernetes_cluster.identity != null || var.kubernetes_cluster.service_principal != null
    error_message = "Either identity or service_principal must be configured."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
} 