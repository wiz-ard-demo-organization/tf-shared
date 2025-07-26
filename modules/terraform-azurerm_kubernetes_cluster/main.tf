# Module for creating and managing Azure Kubernetes Service (AKS) clusters with comprehensive configuration options
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

module "name" {
  source          = "../_global/modules/naming"
  key             = var.key
  global_settings = var.global_settings
  resource_type   = "azurerm_kubernetes_cluster"
}

# Create the AKS cluster with specified configuration for container orchestration
resource "azurerm_kubernetes_cluster" "this" {
  # Core cluster configuration
  name                                = try(var.kubernetes_cluster.name, module.name.result)
  location                            = var.kubernetes_cluster.location
  resource_group_name                 = var.kubernetes_cluster.resource_group_name
  dns_prefix                          = var.kubernetes_cluster.dns_prefix
  dns_prefix_private_cluster          = var.kubernetes_cluster.dns_prefix_private_cluster
  kubernetes_version                  = var.kubernetes_cluster.kubernetes_version
  sku_tier                            = var.kubernetes_cluster.sku_tier
  
  # Network and security configuration
  api_server_authorized_ip_ranges     = var.kubernetes_cluster.api_server_authorized_ip_ranges
  node_resource_group                 = var.kubernetes_cluster.node_resource_group
  disk_encryption_set_id              = var.kubernetes_cluster.disk_encryption_set_id
  private_cluster_enabled             = var.kubernetes_cluster.private_cluster_enabled
  private_dns_zone_id                 = var.kubernetes_cluster.private_dns_zone_id
  private_cluster_public_fqdn_enabled = var.kubernetes_cluster.private_cluster_public_fqdn_enabled
  public_network_access_enabled       = var.kubernetes_cluster.public_network_access_enabled
  
  # Access control and authentication
  role_based_access_control_enabled   = var.kubernetes_cluster.role_based_access_control_enabled
  local_account_disabled              = var.kubernetes_cluster.local_account_disabled
  
  # Upgrade and maintenance settings
  automatic_channel_upgrade           = var.kubernetes_cluster.automatic_channel_upgrade
  node_os_channel_upgrade             = var.kubernetes_cluster.node_os_channel_upgrade
  
  # Add-ons and features
  azure_policy_enabled                = var.kubernetes_cluster.azure_policy_enabled
  # Removed deprecated: http_application_routing_enabled
  # Removed deprecated: open_service_mesh_enabled
  workload_identity_enabled           = var.kubernetes_cluster.workload_identity_enabled
  oidc_issuer_enabled                 = var.kubernetes_cluster.oidc_issuer_enabled
  image_cleaner_enabled               = var.kubernetes_cluster.image_cleaner_enabled
  image_cleaner_interval_hours        = var.kubernetes_cluster.image_cleaner_interval_hours
  cost_analysis_enabled               = var.kubernetes_cluster.cost_analysis_enabled
  run_command_enabled                 = var.kubernetes_cluster.run_command_enabled
  support_plan                        = var.kubernetes_cluster.support_plan

  # Default Node Pool configuration - required system node pool for cluster operation
  default_node_pool {
    # Basic node pool settings
    name                         = var.kubernetes_cluster.default_node_pool.name
    node_count                   = var.kubernetes_cluster.default_node_pool.node_count
    vm_size                      = var.kubernetes_cluster.default_node_pool.vm_size
    vnet_subnet_id               = var.kubernetes_cluster.default_node_pool.vnet_subnet_id
    zones                        = var.kubernetes_cluster.default_node_pool.zones
    
    # Auto-scaling configuration
    enable_auto_scaling          = var.kubernetes_cluster.default_node_pool.enable_auto_scaling
    min_count                    = var.kubernetes_cluster.default_node_pool.min_count
    max_count                    = var.kubernetes_cluster.default_node_pool.max_count
    
    # Pod and storage configuration
    max_pods                     = var.kubernetes_cluster.default_node_pool.max_pods
    os_disk_size_gb              = var.kubernetes_cluster.default_node_pool.os_disk_size_gb
    os_disk_type                 = var.kubernetes_cluster.default_node_pool.os_disk_type
    ultra_ssd_enabled            = var.kubernetes_cluster.default_node_pool.ultra_ssd_enabled
    kubelet_disk_type            = var.kubernetes_cluster.default_node_pool.kubelet_disk_type
    
    # Network settings
    node_public_ip_enabled       = var.kubernetes_cluster.default_node_pool.node_public_ip_enabled
    node_public_ip_prefix_id     = var.kubernetes_cluster.default_node_pool.node_public_ip_prefix_id
    enable_node_public_ip        = var.kubernetes_cluster.default_node_pool.enable_node_public_ip
    pod_subnet_id                = var.kubernetes_cluster.default_node_pool.pod_subnet_id
    
    # Security and encryption
    enable_host_encryption       = var.kubernetes_cluster.default_node_pool.enable_host_encryption
    fips_enabled                 = var.kubernetes_cluster.default_node_pool.fips_enabled
    
    # Advanced configuration
    temporary_name_for_rotation  = var.kubernetes_cluster.default_node_pool.temporary_name_for_rotation
    type                         = var.kubernetes_cluster.default_node_pool.type
    orchestrator_version         = var.kubernetes_cluster.default_node_pool.orchestrator_version
    proximity_placement_group_id = var.kubernetes_cluster.default_node_pool.proximity_placement_group_id
    workload_runtime             = var.kubernetes_cluster.default_node_pool.workload_runtime
    only_critical_addons_enabled = var.kubernetes_cluster.default_node_pool.only_critical_addons_enabled
    scale_down_mode              = var.kubernetes_cluster.default_node_pool.scale_down_mode
    snapshot_id                  = var.kubernetes_cluster.default_node_pool.snapshot_id
    host_group_id                = var.kubernetes_cluster.default_node_pool.host_group_id
    capacity_reservation_group_id = var.kubernetes_cluster.default_node_pool.capacity_reservation_group_id
    gpu_instance_profile         = var.kubernetes_cluster.default_node_pool.gpu_instance_profile
    message_of_the_day           = var.kubernetes_cluster.default_node_pool.message_of_the_day
    node_labels                  = var.kubernetes_cluster.default_node_pool.node_labels
    node_taints                  = var.kubernetes_cluster.default_node_pool.node_taints

    # Kubelet configuration for container runtime tuning
    dynamic "kubelet_config" {
      for_each = var.kubernetes_cluster.default_node_pool.kubelet_config != null ? [var.kubernetes_cluster.default_node_pool.kubelet_config] : []
      content {
        allowed_unsafe_sysctls    = kubelet_config.value.allowed_unsafe_sysctls
        container_log_max_line    = kubelet_config.value.container_log_max_line
        container_log_max_size_mb = kubelet_config.value.container_log_max_size_mb
        cpu_cfs_quota_enabled     = kubelet_config.value.cpu_cfs_quota_enabled
        cpu_cfs_quota_period      = kubelet_config.value.cpu_cfs_quota_period
        cpu_manager_policy        = kubelet_config.value.cpu_manager_policy
        image_gc_high_threshold   = kubelet_config.value.image_gc_high_threshold
        image_gc_low_threshold    = kubelet_config.value.image_gc_low_threshold
        pod_max_pid               = kubelet_config.value.pod_max_pid
        topology_manager_policy   = kubelet_config.value.topology_manager_policy
      }
    }

    # Linux OS configuration for kernel tuning
    dynamic "linux_os_config" {
      for_each = var.kubernetes_cluster.default_node_pool.linux_os_config != null ? [var.kubernetes_cluster.default_node_pool.linux_os_config] : []
      content {
        swap_file_size_mb             = linux_os_config.value.swap_file_size_mb
        transparent_huge_page_enabled = linux_os_config.value.transparent_huge_page_enabled
        transparent_huge_page_defrag  = linux_os_config.value.transparent_huge_page_defrag

        # System control (sysctl) kernel parameters
        dynamic "sysctl_config" {
          for_each = linux_os_config.value.sysctl_config != null ? [linux_os_config.value.sysctl_config] : []
          content {
            fs_aio_max_nr                      = sysctl_config.value.fs_aio_max_nr
            fs_file_max                        = sysctl_config.value.fs_file_max
            fs_inotify_max_user_watches        = sysctl_config.value.fs_inotify_max_user_watches
            fs_nr_open                         = sysctl_config.value.fs_nr_open
            kernel_threads_max                 = sysctl_config.value.kernel_threads_max
            net_core_netdev_max_backlog        = sysctl_config.value.net_core_netdev_max_backlog
            net_core_optmem_max                = sysctl_config.value.net_core_optmem_max
            net_core_rmem_default              = sysctl_config.value.net_core_rmem_default
            net_core_rmem_max                  = sysctl_config.value.net_core_rmem_max
            net_core_somaxconn                 = sysctl_config.value.net_core_somaxconn
            net_core_wmem_default              = sysctl_config.value.net_core_wmem_default
            net_core_wmem_max                  = sysctl_config.value.net_core_wmem_max
            net_ipv4_ip_local_port_range_max   = sysctl_config.value.net_ipv4_ip_local_port_range_max
            net_ipv4_ip_local_port_range_min   = sysctl_config.value.net_ipv4_ip_local_port_range_min
            net_ipv4_neigh_default_gc_thresh1  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh1
            net_ipv4_neigh_default_gc_thresh2  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh2
            net_ipv4_neigh_default_gc_thresh3  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh3
            net_ipv4_tcp_fin_timeout           = sysctl_config.value.net_ipv4_tcp_fin_timeout
            net_ipv4_tcp_keepalive_intvl       = sysctl_config.value.net_ipv4_tcp_keepalive_intvl
            net_ipv4_tcp_keepalive_probes      = sysctl_config.value.net_ipv4_tcp_keepalive_probes
            net_ipv4_tcp_keepalive_time        = sysctl_config.value.net_ipv4_tcp_keepalive_time
            net_ipv4_tcp_max_syn_backlog       = sysctl_config.value.net_ipv4_tcp_max_syn_backlog
            net_ipv4_tcp_max_tw_buckets        = sysctl_config.value.net_ipv4_tcp_max_tw_buckets
            net_ipv4_tcp_tw_reuse              = sysctl_config.value.net_ipv4_tcp_tw_reuse
            net_netfilter_nf_conntrack_buckets = sysctl_config.value.net_netfilter_nf_conntrack_buckets
            net_netfilter_nf_conntrack_max     = sysctl_config.value.net_netfilter_nf_conntrack_max
            vm_max_map_count                   = sysctl_config.value.vm_max_map_count
            vm_swappiness                      = sysctl_config.value.vm_swappiness
            vm_vfs_cache_pressure              = sysctl_config.value.vm_vfs_cache_pressure
          }
        }
      }
    }

    # Node network profile for security group and IP tag configuration
    dynamic "node_network_profile" {
      for_each = var.kubernetes_cluster.default_node_pool.node_network_profile != null ? [var.kubernetes_cluster.default_node_pool.node_network_profile] : []
      content {
        application_security_group_ids = node_network_profile.value.application_security_group_ids
        node_public_ip_tags           = node_network_profile.value.node_public_ip_tags
      }
    }

    # Upgrade settings for controlled node pool updates
    dynamic "upgrade_settings" {
      for_each = var.kubernetes_cluster.default_node_pool.upgrade_settings != null ? [var.kubernetes_cluster.default_node_pool.upgrade_settings] : []
      content {
        drain_timeout_in_minutes      = upgrade_settings.value.drain_timeout_in_minutes
        node_soak_duration_in_minutes = upgrade_settings.value.node_soak_duration_in_minutes
        max_surge                     = upgrade_settings.value.max_surge
      }
    }

    tags = var.tags
  }

  # Network Profile - defines cluster networking architecture and policies
  dynamic "network_profile" {
    for_each = var.kubernetes_cluster.network_profile != null ? [var.kubernetes_cluster.network_profile] : []
    content {
      # Core networking configuration
      network_plugin      = network_profile.value.network_plugin
      network_mode        = network_profile.value.network_mode
      network_policy      = network_profile.value.network_policy
      dns_service_ip      = network_profile.value.dns_service_ip
      # Removed deprecated: docker_bridge_cidr
      outbound_type       = network_profile.value.outbound_type
      
      # IP address ranges for pods and services
      pod_cidr            = network_profile.value.pod_cidr
      pod_cidrs           = network_profile.value.pod_cidrs
      service_cidr        = network_profile.value.service_cidr
      service_cidrs       = network_profile.value.service_cidrs
      ip_versions         = network_profile.value.ip_versions
      
      # Advanced networking features
      load_balancer_sku   = network_profile.value.load_balancer_sku
      network_plugin_mode = network_profile.value.network_plugin_mode
      network_data_plane  = network_profile.value.network_data_plane
      ebpf_data_plane     = network_profile.value.ebpf_data_plane

      # Load balancer configuration for outbound connectivity
      dynamic "load_balancer_profile" {
        for_each = network_profile.value.load_balancer_profile != null ? [network_profile.value.load_balancer_profile] : []
        content {
          idle_timeout_in_minutes     = load_balancer_profile.value.idle_timeout_in_minutes
          managed_outbound_ip_count   = load_balancer_profile.value.managed_outbound_ip_count
          managed_outbound_ipv6_count = load_balancer_profile.value.managed_outbound_ipv6_count
          outbound_ip_address_ids     = load_balancer_profile.value.outbound_ip_address_ids
          outbound_ip_prefix_ids      = load_balancer_profile.value.outbound_ip_prefix_ids
          outbound_ports_allocated    = load_balancer_profile.value.outbound_ports_allocated
        }
      }

      # NAT gateway configuration for outbound connectivity
      dynamic "nat_gateway_profile" {
        for_each = network_profile.value.nat_gateway_profile != null ? [network_profile.value.nat_gateway_profile] : []
        content {
          idle_timeout_in_minutes   = nat_gateway_profile.value.idle_timeout_in_minutes
          managed_outbound_ip_count = nat_gateway_profile.value.managed_outbound_ip_count
        }
      }
    }
  }

  # Identity configuration for managed identity authentication
  dynamic "identity" {
    for_each = var.kubernetes_cluster.identity != null ? [var.kubernetes_cluster.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  # Service Principal configuration for legacy authentication (prefer managed identity)
  dynamic "service_principal" {
    for_each = var.kubernetes_cluster.service_principal != null ? [var.kubernetes_cluster.service_principal] : []
    content {
      client_id     = service_principal.value.client_id
      client_secret = service_principal.value.client_secret
    }
  }

  # Auto Scaler Profile - configures cluster autoscaler behavior
  dynamic "auto_scaler_profile" {
    for_each = var.kubernetes_cluster.auto_scaler_profile != null ? [var.kubernetes_cluster.auto_scaler_profile] : []
    content {
      balance_similar_node_groups      = auto_scaler_profile.value.balance_similar_node_groups
      expander                         = auto_scaler_profile.value.expander
      max_graceful_termination_sec     = auto_scaler_profile.value.max_graceful_termination_sec
      max_node_provisioning_time       = auto_scaler_profile.value.max_node_provisioning_time
      max_unready_nodes                = auto_scaler_profile.value.max_unready_nodes
      max_unready_percentage           = auto_scaler_profile.value.max_unready_percentage
      new_pod_scale_up_delay           = auto_scaler_profile.value.new_pod_scale_up_delay
      scale_down_delay_after_add       = auto_scaler_profile.value.scale_down_delay_after_add
      scale_down_delay_after_delete    = auto_scaler_profile.value.scale_down_delay_after_delete
      scale_down_delay_after_failure   = auto_scaler_profile.value.scale_down_delay_after_failure
      scan_interval                    = auto_scaler_profile.value.scan_interval
      scale_down_unneeded              = auto_scaler_profile.value.scale_down_unneeded
      scale_down_unready               = auto_scaler_profile.value.scale_down_unready
      scale_down_utilization_threshold = auto_scaler_profile.value.scale_down_utilization_threshold
      empty_bulk_delete_max            = auto_scaler_profile.value.empty_bulk_delete_max
      skip_nodes_with_local_storage    = auto_scaler_profile.value.skip_nodes_with_local_storage
      skip_nodes_with_system_pods      = auto_scaler_profile.value.skip_nodes_with_system_pods
    }
  }

  # API Server Access Profile - controls API server network accessibility
  dynamic "api_server_access_profile" {
    for_each = var.kubernetes_cluster.api_server_access_profile != null ? [var.kubernetes_cluster.api_server_access_profile] : []
    content {
      authorized_ip_ranges     = api_server_access_profile.value.authorized_ip_ranges
      vnet_integration_enabled = api_server_access_profile.value.vnet_integration_enabled
      subnet_id                = api_server_access_profile.value.subnet_id
    }
  }

  # Azure Active Directory Role Based Access Control for cluster authentication
  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.kubernetes_cluster.azure_active_directory_role_based_access_control != null ? [var.kubernetes_cluster.azure_active_directory_role_based_access_control] : []
    content {
      managed                = azure_active_directory_role_based_access_control.value.managed
      tenant_id              = azure_active_directory_role_based_access_control.value.tenant_id
      admin_group_object_ids = azure_active_directory_role_based_access_control.value.admin_group_object_ids
      azure_rbac_enabled     = azure_active_directory_role_based_access_control.value.azure_rbac_enabled
      # Removed deprecated: client_app_id, server_app_id, server_app_secret
    }
  }

  # HTTP Proxy Config - configures proxy settings for cluster egress traffic
  dynamic "http_proxy_config" {
    for_each = var.kubernetes_cluster.http_proxy_config != null ? [var.kubernetes_cluster.http_proxy_config] : []
    content {
      http_proxy  = http_proxy_config.value.http_proxy
      https_proxy = http_proxy_config.value.https_proxy
      no_proxy    = http_proxy_config.value.no_proxy
      trusted_ca  = http_proxy_config.value.trusted_ca
    }
  }

  # OMS Agent - enables Azure Monitor for containers
  dynamic "oms_agent" {
    for_each = var.kubernetes_cluster.oms_agent != null ? [var.kubernetes_cluster.oms_agent] : []
    content {
      log_analytics_workspace_id      = oms_agent.value.log_analytics_workspace_id
      msi_auth_for_monitoring_enabled = oms_agent.value.msi_auth_for_monitoring_enabled
    }
  }

  # Ingress Application Gateway - integrates Azure Application Gateway as ingress controller
  dynamic "ingress_application_gateway" {
    for_each = var.kubernetes_cluster.ingress_application_gateway != null ? [var.kubernetes_cluster.ingress_application_gateway] : []
    content {
      gateway_id   = ingress_application_gateway.value.gateway_id
      gateway_name = ingress_application_gateway.value.gateway_name
      subnet_cidr  = ingress_application_gateway.value.subnet_cidr
      subnet_id    = ingress_application_gateway.value.subnet_id
    }
  }

  # Key Vault Secrets Provider - enables secrets store CSI driver for Azure Key Vault
  dynamic "key_vault_secrets_provider" {
    for_each = var.kubernetes_cluster.key_vault_secrets_provider != null ? [var.kubernetes_cluster.key_vault_secrets_provider] : []
    content {
      secret_rotation_enabled  = key_vault_secrets_provider.value.secret_rotation_enabled
      secret_rotation_interval = key_vault_secrets_provider.value.secret_rotation_interval
    }
  }

  # Linux Profile - SSH configuration for Linux nodes
  dynamic "linux_profile" {
    for_each = var.kubernetes_cluster.linux_profile != null ? [var.kubernetes_cluster.linux_profile] : []
    content {
      admin_username = linux_profile.value.admin_username

      ssh_key {
        key_data = linux_profile.value.ssh_key.key_data
      }
    }
  }

  # Windows Profile - configuration for Windows node pools
  dynamic "windows_profile" {
    for_each = var.kubernetes_cluster.windows_profile != null ? [var.kubernetes_cluster.windows_profile] : []
    content {
      admin_username = windows_profile.value.admin_username
      admin_password = windows_profile.value.admin_password
      license        = windows_profile.value.license

      # Group Managed Service Account configuration for Windows containers
      dynamic "gmsa" {
        for_each = windows_profile.value.gmsa != null ? [windows_profile.value.gmsa] : []
        content {
          dns_server  = gmsa.value.dns_server
          root_domain = gmsa.value.root_domain
        }
      }
    }
  }

  # Maintenance Window - defines allowed times for cluster maintenance
  dynamic "maintenance_window" {
    for_each = var.kubernetes_cluster.maintenance_window != null ? [var.kubernetes_cluster.maintenance_window] : []
    content {
      # Allowed maintenance windows
      dynamic "allowed" {
        for_each = maintenance_window.value.allowed != null ? maintenance_window.value.allowed : []
        content {
          day   = allowed.value.day
          hours = allowed.value.hours
        }
      }

      # Blocked time periods for maintenance
      dynamic "not_allowed" {
        for_each = maintenance_window.value.not_allowed != null ? maintenance_window.value.not_allowed : []
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }

  # Maintenance Window Auto Upgrade - schedule for automatic cluster upgrades
  dynamic "maintenance_window_auto_upgrade" {
    for_each = var.kubernetes_cluster.maintenance_window_auto_upgrade != null ? [var.kubernetes_cluster.maintenance_window_auto_upgrade] : []
    content {
      frequency   = maintenance_window_auto_upgrade.value.frequency
      interval    = maintenance_window_auto_upgrade.value.interval
      duration    = maintenance_window_auto_upgrade.value.duration
      day_of_week = maintenance_window_auto_upgrade.value.day_of_week
      day_of_month = maintenance_window_auto_upgrade.value.day_of_month
      week_index  = maintenance_window_auto_upgrade.value.week_index
      start_time  = maintenance_window_auto_upgrade.value.start_time
      utc_offset  = maintenance_window_auto_upgrade.value.utc_offset
      start_date  = maintenance_window_auto_upgrade.value.start_date

      # Blocked time periods for auto upgrades
      dynamic "not_allowed" {
        for_each = maintenance_window_auto_upgrade.value.not_allowed != null ? maintenance_window_auto_upgrade.value.not_allowed : []
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }

  # Maintenance Window Node OS - schedule for node OS updates
  dynamic "maintenance_window_node_os" {
    for_each = var.kubernetes_cluster.maintenance_window_node_os != null ? [var.kubernetes_cluster.maintenance_window_node_os] : []
    content {
      frequency   = maintenance_window_node_os.value.frequency
      interval    = maintenance_window_node_os.value.interval
      duration    = maintenance_window_node_os.value.duration
      day_of_week = maintenance_window_node_os.value.day_of_week
      day_of_month = maintenance_window_node_os.value.day_of_month
      week_index  = maintenance_window_node_os.value.week_index
      start_time  = maintenance_window_node_os.value.start_time
      utc_offset  = maintenance_window_node_os.value.utc_offset
      start_date  = maintenance_window_node_os.value.start_date

      # Blocked time periods for node OS updates
      dynamic "not_allowed" {
        for_each = maintenance_window_node_os.value.not_allowed != null ? maintenance_window_node_os.value.not_allowed : []
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }

  # Microsoft Defender - enables security monitoring and threat protection
  dynamic "microsoft_defender" {
    for_each = var.kubernetes_cluster.microsoft_defender != null ? [var.kubernetes_cluster.microsoft_defender] : []
    content {
      log_analytics_workspace_id = microsoft_defender.value.log_analytics_workspace_id
    }
  }

  # Monitor Metrics - configures Prometheus metrics collection
  dynamic "monitor_metrics" {
    for_each = var.kubernetes_cluster.monitor_metrics != null ? [var.kubernetes_cluster.monitor_metrics] : []
    content {
      annotations_allowed = monitor_metrics.value.annotations_allowed
      labels_allowed      = monitor_metrics.value.labels_allowed
    }
  }

  # Storage Profile - configures CSI storage drivers
  dynamic "storage_profile" {
    for_each = var.kubernetes_cluster.storage_profile != null ? [var.kubernetes_cluster.storage_profile] : []
    content {
      blob_driver_enabled         = storage_profile.value.blob_driver_enabled
      disk_driver_enabled         = storage_profile.value.disk_driver_enabled
      disk_driver_version         = storage_profile.value.disk_driver_version
      file_driver_enabled         = storage_profile.value.file_driver_enabled
      snapshot_controller_enabled = storage_profile.value.snapshot_controller_enabled
    }
  }

  # Web App Routing - enables managed NGINX ingress controller with DNS integration
  dynamic "web_app_routing" {
    for_each = var.kubernetes_cluster.web_app_routing != null ? [var.kubernetes_cluster.web_app_routing] : []
    content {
      dns_zone_id              = web_app_routing.value.dns_zone_id
      dns_zone_ids             = web_app_routing.value.dns_zone_ids
      web_app_routing_identity = web_app_routing.value.web_app_routing_identity
    }
  }

  # Workload Autoscaler Profile - enables advanced autoscaling features
  dynamic "workload_autoscaler_profile" {
    for_each = var.kubernetes_cluster.workload_autoscaler_profile != null ? [var.kubernetes_cluster.workload_autoscaler_profile] : []
    content {
      keda_enabled                    = workload_autoscaler_profile.value.keda_enabled
      vertical_pod_autoscaler_enabled = workload_autoscaler_profile.value.vertical_pod_autoscaler_enabled
    }
  }

  # Service Mesh Profile - configures Istio-based service mesh
  dynamic "service_mesh_profile" {
    for_each = var.kubernetes_cluster.service_mesh_profile != null ? [var.kubernetes_cluster.service_mesh_profile] : []
    content {
      mode                             = service_mesh_profile.value.mode
      internal_ingress_gateway_enabled = service_mesh_profile.value.internal_ingress_gateway_enabled
      external_ingress_gateway_enabled = service_mesh_profile.value.external_ingress_gateway_enabled
    }
  }

  tags = var.tags
} 