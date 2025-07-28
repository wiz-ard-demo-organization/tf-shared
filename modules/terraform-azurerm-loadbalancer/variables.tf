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

variable "load_balancer" {
  description = <<EOT
    load_balancer = {
      name : "(Required) Specifies the name of the Load Balancer. Changing this forces a new resource to be created."
      location : "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
      resource_group_name : "(Required) The name of the resource group in which to create the resource. Changing this forces a new resource to be created."
      sku : "(Optional) The SKU of the Load Balancer. Possible values are Basic, Standard and Gateway. Defaults to Basic. Changing this forces a new resource to be created."
      sku_tier : "(Optional) The SKU tier of this Load Balancer. Possible values are Global and Regional. Defaults to Regional. Changing this forces a new resource to be created."
      edge_zone : "(Optional) Specifies the Edge Zone within the Azure Region where this Load Balancer should exist. Changing this forces a new resource to be created."
      frontend_ip_configuration : (Required) One or more frontend_ip_configuration blocks. {
        name : "(Required) Specifies the name of the frontend IP configuration."
        zones : "(Optional) Specifies a list of Availability Zones in which the IP Address for this Load Balancer should be located."
        subnet_id : "(Optional) The ID of the Subnet which should be associated with the IP Configuration."
        private_ip_address : "(Optional) Private IP Address to assign to the Load Balancer."
        private_ip_address_allocation : "(Optional) The allocation method for the Private IP Address used by this Load Balancer. Possible values are Dynamic and Static."
        private_ip_address_version : "(Optional) The version of IP that the Private IP Address is. Possible values are IPv4 or IPv6."
        public_ip_address_id : "(Optional) The ID of a Public IP Address which should be associated with the Load Balancer."
        public_ip_prefix_id : "(Optional) The ID of a Public IP Prefix which should be associated with the Load Balancer."
        gateway_load_balancer_frontend_ip_configuration_id : "(Optional) The Frontend IP Configuration ID of a Gateway SKU Load Balancer."
      }
    }
  EOT
  type = object({
    name                = optional(string)
    location            = optional(string)
    resource_group_name = optional(string)
    sku                 = optional(string)
    sku_tier            = optional(string)
    edge_zone           = optional(string)

    frontend_ip_configuration = optional(list(object({
      name                          = string
      zones                         = optional(list(string))
      subnet_id                     = optional(string)
      private_ip_address            = optional(string)
      private_ip_address_allocation = optional(string)
      private_ip_address_version    = optional(string)
      public_ip_address_id          = optional(string)
      public_ip_prefix_id           = optional(string)
      gateway_load_balancer_frontend_ip_configuration_id = optional(string)
    })))
  })
  default = null
}

variable "backend_address_pools" {
  description = <<EOT
    backend_address_pools = {
      name : "(Required) Specifies the name of the Backend Address Pool. Changing this forces a new resource to be created."
      tunnel_interface : (Optional) One or more tunnel_interface blocks for Gateway Load Balancer. {
        identifier : "(Required) The unique identifier of this Gateway Load Balancer Tunnel Interface."
        type : "(Required) The traffic type of this Gateway Load Balancer Tunnel Interface. Possible values are Internal and External."
        protocol : "(Required) The protocol used for this Gateway Load Balancer Tunnel Interface. Possible values are Native and VXLAN."
        port : "(Required) The port used for this Gateway Load Balancer Tunnel Interface."
      }
    }
  EOT
  type = map(object({
    name = string

    tunnel_interface = optional(list(object({
      identifier = number
      type       = string
      protocol   = string
      port       = number
    })))
  }))
  default = {}
}

variable "backend_address_pool_addresses" {
  description = <<EOT
    backend_address_pool_addresses = {
      name : "(Required) The name which should be used for this Backend Address Pool Address. Changing this forces a new Backend Address Pool Address to be created."
      backend_address_pool_key : "(Required) The key referencing the Backend Address Pool to which this Backend Address Pool Address belongs."
      virtual_network_id : "(Required) The ID of the Virtual Network within which the Backend Address Pool should exist."
      ip_address : "(Required) The Static IP Address which should be allocated to this Backend Address Pool."
      # Note: inbound_nat_rule_port_mapping is a computed attribute set by Azure
      # and cannot be configured manually. It will be automatically populated
      # when NAT rules are associated with this backend address pool.
    }
  EOT
  type = map(object({
    name                     = string
    backend_address_pool_key = string
    virtual_network_id       = string
    ip_address               = string
  }))
  default = {}
}

variable "health_probes" {
  description = <<EOT
    health_probes = {
      name : "(Required) Specifies the name of the Probe. Changing this forces a new resource to be created."
      protocol : "(Required) Specifies the protocol of the end point. Possible values are Http, Https or Tcp."
      port : "(Required) Port on which the Probe queries the backend endpoint."
      probe_threshold : "(Optional) The number of consecutive successful or failed probes that allow or deny traffic to this endpoint. Possible values range from 1 to 100. The default value is 1."
      request_path : "(Optional) The URI used for requesting health status from the backend endpoint. Required if protocol is set to Http or Https. Otherwise, it is not allowed."
      interval_in_seconds : "(Optional) The interval, in seconds between probes to the backend endpoint for health status. The default value is 15."
      number_of_probes : "(Optional) The number of failed probe attempts after which the backend endpoint is removed from rotation. Default is 2."
    }
  EOT
  type = map(object({
    name                = string
    protocol            = string
    port                = number
    probe_threshold     = optional(number)
    request_path        = optional(string)
    interval_in_seconds = optional(number)
    number_of_probes    = optional(number)
  }))
  default = {}
}

variable "load_balancing_rules" {
  description = <<EOT
    load_balancing_rules = {
      name : "(Required) Specifies the name of the LB Rule. Changing this forces a new resource to be created."
      protocol : "(Required) The transport protocol for the external endpoint. Possible values are Tcp, Udp or All."
      frontend_port : "(Required) The port for the external endpoint. Port numbers for each Rule must be unique within the Load Balancer."
      backend_port : "(Required) The port used for internal connections on the endpoint."
      frontend_ip_configuration_name : "(Required) The name of the frontend IP configuration to which the rule is associated."
      backend_address_pool_keys : "(Required) A list of reference keys to backend address pool resources."
      probe_key : "(Optional) A reference key to a Probe resource used by this Load Balancing Rule."
      enable_floating_ip : "(Optional) Are the Floating IPs enabled for this Load Balancer Rule? A 'floating' IP is reassigned to a secondary server in case the primary server fails. Required to configure a SQL AlwaysOn Availability Group."
      idle_timeout_in_minutes : "(Optional) Specifies the idle timeout in minutes for TCP connections. Valid values are between 4 and 100. Defaults to 4."
      load_distribution : "(Optional) Specifies the load balancing distribution type to be used by the Load Balancer. Possible values are Default, SourceIP, SourceIPProtocol."
      disable_outbound_snat : "(Optional) Is snat enabled for this Load Balancer Rule? Defaults to false."
      enable_tcp_reset : "(Optional) Is TCP Reset enabled for this Load Balancer Rule?"
    }
  EOT
  type = map(object({
    name                           = string
    protocol                       = string
    frontend_port                  = number
    backend_port                   = number
    frontend_ip_configuration_name = string
    backend_address_pool_keys      = list(string)
    probe_key                      = optional(string)
    enable_floating_ip             = optional(bool)
    idle_timeout_in_minutes        = optional(number)
    load_distribution              = optional(string)
    disable_outbound_snat          = optional(bool)
    enable_tcp_reset               = optional(bool)
  }))
  default = {}
}

variable "nat_rules" {
  description = <<EOT
    nat_rules = {
      name : "(Required) Specifies the name of the NAT Rule. Changing this forces a new resource to be created."
      protocol : "(Required) The transport protocol for the external endpoint. Possible values are Tcp, Udp or All."
      frontend_port : "(Required) The port for the external endpoint. Port numbers for each Rule must be unique within the Load Balancer."
      backend_port : "(Required) The port used for the internal endpoint."
      frontend_ip_configuration_name : "(Required) The name of the frontend IP configuration exposing this rule."
      idle_timeout_in_minutes : "(Optional) Specifies the idle timeout in minutes for TCP connections. Valid values are between 4 and 30. Defaults to 4."
      enable_floating_ip : "(Optional) Are the Floating IPs enabled for this Load Balancer Rule? A 'floating' IP is reassigned to a secondary server in case the primary server fails."
      enable_tcp_reset : "(Optional) Is TCP Reset enabled for this Load Balancer Rule?"
    }
  EOT
  type = map(object({
    name                           = string
    protocol                       = string
    frontend_port                  = number
    backend_port                   = number
    frontend_ip_configuration_name = string
    idle_timeout_in_minutes        = optional(number)
    enable_floating_ip             = optional(bool)
    enable_tcp_reset               = optional(bool)
  }))
  default = {}
}

variable "outbound_rules" {
  description = <<EOT
    outbound_rules = {
      name : "(Required) Specifies the name of the Outbound Rule. Changing this forces a new resource to be created."
      protocol : "(Required) The transport protocol for the external endpoint. Possible values are Tcp, Udp or All."
      backend_address_pool_key : "(Required) The key referencing a Backend Address Pool used by this Outbound Rule."
      frontend_ip_configuration_names : "(Required) One or more frontend IP configuration names from the Load Balancer."
      allocated_outbound_ports : "(Optional) The number of outbound ports to be used for NAT. Defaults to 1024."
      idle_timeout_in_minutes : "(Optional) The timeout for the TCP idle connection in minutes. Valid values are between 4 and 66. Defaults to 4."
      enable_tcp_reset : "(Optional) Receive bidirectional TCP Reset on TCP flow idle timeout or unexpected connection termination."
    }
  EOT
  type = map(object({
    name                            = string
    protocol                        = string
    backend_address_pool_key        = string
    frontend_ip_configuration_names = list(string)
    allocated_outbound_ports        = optional(number)
    idle_timeout_in_minutes         = optional(number)
    enable_tcp_reset                = optional(bool)
  }))
  default = {}
}

variable "nat_pools" {
  description = <<EOT
    nat_pools = {
      name : "(Required) Specifies the name of the NAT pool. Changing this forces a new resource to be created."
      protocol : "(Required) The transport protocol for the external endpoint. Possible values are All, Tcp and Udp."
      frontend_port_start : "(Required) The first port number in the range of external ports that will be used to provide Inbound NAT to NICs associated with this Load Balancer."
      frontend_port_end : "(Required) The last port number in the range of external ports that will be used to provide Inbound NAT to NICs associated with this Load Balancer."
      backend_port : "(Required) The port used for the internal endpoint."
      frontend_ip_configuration_name : "(Required) The name of the frontend IP configuration exposing this rule."
      idle_timeout_in_minutes : "(Optional) Specifies the idle timeout in minutes for TCP connections. Valid values are between 4 and 30. Defaults to 4."
      floating_ip_enabled : "(Optional) Are the floating IPs enabled for this Load Balancer Rule? A floating IP is reassigned to a secondary server in case the primary server fails."
      tcp_reset_enabled : "(Optional) Is TCP Reset enabled for this Load Balancer Rule?"
    }
  EOT
  type = map(object({
    name                           = string
    protocol                       = string
    frontend_port_start            = number
    frontend_port_end              = number
    backend_port                   = number
    frontend_ip_configuration_name = string
    idle_timeout_in_minutes        = optional(number)
    floating_ip_enabled            = optional(bool)
    tcp_reset_enabled              = optional(bool)
  }))
  default = {}
}

variable "public_ips" {
  type        = any
  default     = {}
  description = "Public IP addresses previously created and being referenced with an Instance key"
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to all resources created by this module."
  type        = map(string)
  default     = {}
} 