variable "load_balancer" {
  description = "Configuration for the Azure Load Balancer"
  type = object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = optional(string)
    sku_tier            = optional(string)
    edge_zone           = optional(string)

    frontend_ip_configuration = list(object({
      name                          = string
      zones                         = optional(list(string))
      subnet_id                     = optional(string)
      private_ip_address            = optional(string)
      private_ip_address_allocation = optional(string)
      private_ip_address_version    = optional(string)
      public_ip_address_id          = optional(string)
      public_ip_prefix_id           = optional(string)
      gateway_load_balancer_frontend_ip_configuration_id = optional(string)
    }))
  })

  validation {
    condition = var.load_balancer.sku == null || contains(["Basic", "Standard", "Gateway"], var.load_balancer.sku)
    error_message = "Load Balancer SKU must be one of: 'Basic', 'Standard', or 'Gateway'."
  }

  validation {
    condition = var.load_balancer.sku_tier == null || contains(["Regional", "Global"], var.load_balancer.sku_tier)
    error_message = "Load Balancer SKU tier must be one of: 'Regional' or 'Global'."
  }

  validation {
    condition = length(var.load_balancer.frontend_ip_configuration) > 0
    error_message = "At least one frontend IP configuration must be specified."
  }
}

variable "backend_address_pools" {
  description = "Map of backend address pools to create"
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
  description = "Map of backend address pool addresses"
  type = map(object({
    name                       = string
    backend_address_pool_key   = string
    virtual_network_id         = string
    ip_address                 = string

    inbound_nat_rule_port_mapping = optional(list(object({
      inbound_nat_rule_name = string
      frontend_port         = number
      backend_port          = number
    })))
  }))
  default = {}
}

variable "health_probes" {
  description = "Map of health probes to create"
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

  validation {
    condition = alltrue([
      for probe in var.health_probes : contains(["Http", "Https", "Tcp"], probe.protocol)
    ])
    error_message = "Health probe protocol must be one of: 'Http', 'Https', or 'Tcp'."
  }

  validation {
    condition = alltrue([
      for probe in var.health_probes : probe.protocol != "Http" && probe.protocol != "Https" || probe.request_path != null
    ])
    error_message = "Request path is required for HTTP and HTTPS health probes."
  }
}

variable "load_balancing_rules" {
  description = "Map of load balancing rules to create"
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

  validation {
    condition = alltrue([
      for rule in var.load_balancing_rules : contains(["Tcp", "Udp", "All"], rule.protocol)
    ])
    error_message = "Load balancing rule protocol must be one of: 'Tcp', 'Udp', or 'All'."
  }

  validation {
    condition = alltrue([
      for rule in var.load_balancing_rules : rule.load_distribution == null || contains(["Default", "SourceIP", "SourceIPProtocol"], rule.load_distribution)
    ])
    error_message = "Load distribution must be one of: 'Default', 'SourceIP', or 'SourceIPProtocol'."
  }
}

variable "nat_rules" {
  description = "Map of NAT rules to create"
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

  validation {
    condition = alltrue([
      for rule in var.nat_rules : contains(["Tcp", "Udp", "All"], rule.protocol)
    ])
    error_message = "NAT rule protocol must be one of: 'Tcp', 'Udp', or 'All'."
  }
}

variable "outbound_rules" {
  description = "Map of outbound rules to create"
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

  validation {
    condition = alltrue([
      for rule in var.outbound_rules : contains(["Tcp", "Udp", "All"], rule.protocol)
    ])
    error_message = "Outbound rule protocol must be one of: 'Tcp', 'Udp', or 'All'."
  }
}

variable "nat_pools" {
  description = "Map of NAT pools to create (for Virtual Machine Scale Sets)"
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

  validation {
    condition = alltrue([
      for pool in var.nat_pools : contains(["Tcp", "Udp", "All"], pool.protocol)
    ])
    error_message = "NAT pool protocol must be one of: 'Tcp', 'Udp', or 'All'."
  }

  validation {
    condition = alltrue([
      for pool in var.nat_pools : pool.frontend_port_start <= pool.frontend_port_end
    ])
    error_message = "Frontend port start must be less than or equal to frontend port end."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
} 