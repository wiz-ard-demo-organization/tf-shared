locals {
  resource_types = {
    azuread_application = {
      slug = "sp"
    }
    azurerm_resource_group = {
      slug = "rg"
    }
    azurerm_storage_account = {
      separator         = ""
      organization_code = true
      slug              = "sa"
    }
    azurerm_key_vault = {
      separator         = ""
      organization_code = true
      slug              = "kv"
    }
    azurerm_log_analytics_workspace = {
      slug = "log"
    }
    azurerm_role_assignment = {
      slug = "ra"
    }
    azurerm_virtual_network = {
      slug = "vnet"
    }
    azurerm_subnet = {
      slug = "snet"
    }
    azurerm_network_security_group = {
      slug = "nsg"
    }
    azurerm_virtual_network_peering = {
      slug = "peer"
    }
    azurerm_network_interface = {
      slug = "nic"
    }
    azurerm_public_ip = {
      slug = "pip"
    }
    azurerm_linux_virtual_machine = {
      slug = "vm"
    }
    azurerm_bastion_host = {
      slug = "bas"
    }
    azurerm_user_assigned_identity = {
      slug = "id"
    }
    azurerm_subscription = {
      slug = "sub"
    }
    azurerm_event_hub_namespace = {
      slug = "evhns"
    }
    azurerm_event_hub = {
      slug = "evh"
    }
    azurerm_route_table = {
      slug = "rt"
    }
    azurerm_route = {
      slug = "udr"
    }
    azurerm_lb = {
      slug = "lb"
    }
    azurerm_lb_rule = {
      slug = "lbrule"
    }
    azurerm_lb_backend_address_pool = {
      slug = "lbpool"
    }
    azurerm_lb_probe = {
      slug = "lbprobe"
    }
    azurerm_lb_outbound_rule = {
      slug = "lboutrule"
    }
    azurerm_network_interface_backend_address_pool_association = {
      slug = "nictolb"
    }
    azurerm_network_watcher = {
      slug = "nw"
    }
    azurerm_monitor_action_group = {
      slug = "ag"
    }
    azurerm_firewall = {
      slug = "afw"
    }
    azurerm_firewall_policy = {
      slug = "afwp"
    }
    azurerm_application_gateway = {
      slug = "agw"
    }
    azurerm_key_vault_key = {
      slug = "key"
    }
    azurerm_key_vault_secret = {
      slug = "secret"
    }
    azurerm_policy_set_definition = {
      slug = "apsd"
    }
    azurerm_policy_assignment = {
      slug = "apa"
    }
    azurerm_private_dns_zone = {
      slug = "dns"
    }
    azurerm_private_dns_resolver = {
      slug = "dnspr"
    }
    azurerm_private_dns_resolver_inbound_endpoint = {
      slug = "in"
    }
    azurerm_private_dns_resolver_outbound_endpoint = {
      slug = "out"
    }
    azurerm_private_dns_resolver_dns_forwarding_ruleset = {
      slug = "rlset"
    }
    azurerm_private_dns_resolver_forwarding_rule = {
      slig = "rl"
    }
    azurerm_virtual_network_gateway = {
      slug = "vnetgateway"
    }
    azurerm_virtual_network_gateway_connection = {
      slug = "vnetgatewayconn"
    }
    azurerm_local_network_gateway = {
      slug = "localgw"
    }
    azurerm_mssql_server = {
      slug = "sql"
    }
    azurerm_mssql_database = {
      slug = "sqldb"
    }
    azurerm_windows_virtual_machine = {
      slug = "vm"
    }
    azurerm_private_link_service = {
      slug = "prvlink"
    }
    azurerm_private_endpoint = {
      slug = "endpoint"
    }
    azurerm_nat_gateway = {
      slug = "nat"
    }
    azurerm_data_factory = {
      slug = "adf"
    }
    azurerm_synapse_private_link_hub = {
      slug              = "plh"
      separator         = ""
      organization_code = true
    }
    azurerm_container_registry = {
      slug              = "cr"
      organization_code = true
      separator         = ""
    }
    azurerm_container_instance = {
      slug = "ci"
    }
    azurerm_container_app = {
      slug = "ca"
    }
    azurerm_container_app_environment = {
      slug = "cae"
    } 
  }
}
