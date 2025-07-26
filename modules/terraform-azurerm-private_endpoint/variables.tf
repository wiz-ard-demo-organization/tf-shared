variable "key" {
  type        = string
  default     = null
  description = "Identifies the specific resource instance being deployed"
}

variable "global_settings" {
  type        = any
  default     = {}
  description = "Global configurations for the Azure Landing Zone"
}

variable "private_endpoint" {
  description = "Configuration for the Private Endpoint"
  type = object({
    name                          = string
    location                      = string
    resource_group_name           = string
    subnet_id                     = string
    custom_network_interface_name = optional(string)

    private_service_connection = object({
      name                              = string
      private_connection_resource_id    = optional(string)
      group_ids                         = optional(list(string))
      subresource_names                 = optional(list(string))
      is_manual_connection              = optional(bool, false)
      private_connection_resource_alias = optional(string)
      request_message                   = optional(string)
    })

    private_dns_zone_group = optional(object({
      name                 = string
      private_dns_zone_ids = list(string)
    }))

    ip_configuration = optional(list(object({
      name               = string
      private_ip_address = string
      subresource_name   = optional(string)
      member_name        = optional(string)
    })))
  })

  validation {
    condition = (
      var.private_endpoint.private_service_connection.private_connection_resource_id != null ||
      var.private_endpoint.private_service_connection.private_connection_resource_alias != null
    )
    error_message = "Either private_connection_resource_id or private_connection_resource_alias must be specified."
  }

  validation {
    condition = (
      var.private_endpoint.private_service_connection.is_manual_connection == false ||
      var.private_endpoint.private_service_connection.request_message != null
    )
    error_message = "request_message is required when is_manual_connection is true."
  }

  validation {
    condition = (
      var.private_endpoint.private_service_connection.group_ids != null ||
      var.private_endpoint.private_service_connection.subresource_names != null
    )
    error_message = "Either group_ids or subresource_names must be specified."
  }
}

variable "private_dns_zones" {
  description = "Map of Private DNS Zones to create"
  type = map(object({
    name = string

    soa_record = optional(object({
      email         = string
      expire_time   = optional(number)
      minimum_ttl   = optional(number)
      refresh_time  = optional(number)
      retry_time    = optional(number)
      serial_number = optional(number)
      ttl           = optional(number)
      tags          = optional(map(string))
    }))
  }))
  default = {}

  validation {
    condition = alltrue([
      for zone in var.private_dns_zones : can(regex("^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$", split(".", zone.name)[0]))
    ])
    error_message = "Private DNS zone names must be valid DNS names."
  }
}

variable "private_dns_zone_virtual_network_links" {
  description = "Map of Private DNS Zone Virtual Network Links"
  type = map(object({
    name                 = string
    private_dns_zone_key = string
    virtual_network_id   = string
    registration_enabled = optional(bool, false)
  }))
  default = {}
}

variable "private_dns_a_records" {
  description = "Map of Private DNS A Records to create"
  type = map(object({
    name                 = string
    private_dns_zone_key = string
    ttl                  = optional(number, 300)
    records              = list(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for record in var.private_dns_a_records : length(record.records) > 0
    ])
    error_message = "Each DNS A record must have at least one IP address."
  }

  validation {
    condition = alltrue([
      for record in var.private_dns_a_records : alltrue([
        for ip in record.records : can(cidrhost("${ip}/32", 0))
      ])
    ])
    error_message = "All records must be valid IP addresses."
  }

  validation {
    condition = alltrue([
      for record in var.private_dns_a_records : record.ttl >= 1 && record.ttl <= 2147483647
    ])
    error_message = "TTL must be between 1 and 2147483647 seconds."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
} 