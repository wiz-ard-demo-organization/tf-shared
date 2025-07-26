variable "private_endpoint" {
  description = <<EOT
    private_endpoint = {
      name : "(Required) Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created."
      location : "(Required) The supported Azure location where the resource exists. Changing this forces a new resource to be created."
      resource_group_name : "(Required) Specifies the Name of the Resource Group within which the Private Endpoint should exist. Changing this forces a new resource to be created."
      subnet_id : "(Required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created."
      custom_network_interface_name : "(Optional) The custom name of the network interface attached to the private endpoint. Changing this forces a new resource to be created."
      private_service_connection : (Required) A private_service_connection block. {
        name : "(Required) Specifies the Name of the Private Service Connection. Changing this forces a new resource to be created."
        private_connection_resource_id : "(Optional) The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to. Conflicts with private_connection_resource_alias. Changing this forces a new resource to be created."
        group_ids : "(Optional) A list of subresource group ids to associate with the Private Endpoint. Required for some services. Changing this forces a new resource to be created."
        subresource_names : "(Optional) A list of subresource names which the Private Endpoint is able to connect to. Changing this forces a new resource to be created."
        is_manual_connection : "(Optional) Does the Private Endpoint require Manual Approval from the remote resource owner? Defaults to false."
        private_connection_resource_alias : "(Optional) The Service Alias of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to. Conflicts with private_connection_resource_id. Changing this forces a new resource to be created."
        request_message : "(Optional) A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource. Required when is_manual_connection is true."
      }
      private_dns_zone_group : (Optional) A private_dns_zone_group block. {
        name : "(Required) Specifies the Name of the Private DNS Zone Group."
        private_dns_zone_ids : "(Required) Specifies the list of Private DNS Zones to include within the private_dns_zone_group."
      }
      ip_configuration : (Optional) One or more ip_configuration blocks. {
        name : "(Required) Specifies the Name of the IP Configuration. Changing this forces a new resource to be created."
        private_ip_address : "(Required) Specifies the static IP address within the private endpoint's subnet to be used. Changing this forces a new resource to be created."
        subresource_name : "(Optional) Specifies the subresource this IP address applies to. Changing this forces a new resource to be created."
        member_name : "(Optional) Specifies the member name this IP address applies to. Changing this forces a new resource to be created."
      }
    }
  EOT
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
  description = <<EOT
    private_dns_zones = {
      name : "(Required) The name of the Private DNS Zone. Must be a valid domain name. Changing this forces a new resource to be created."
      soa_record : (Optional) An soa_record block. {
        email : "(Required) The email contact for the SOA record."
        expire_time : "(Optional) The expire time for the SOA record. Defaults to 2419200."
        minimum_ttl : "(Optional) The minimum Time To Live for the SOA record. By convention, it is used to determine the negative caching duration. Defaults to 10."
        refresh_time : "(Optional) The refresh time for the SOA record. Defaults to 3600."
        retry_time : "(Optional) The retry time for the SOA record. Defaults to 300."
        serial_number : "(Optional) The serial number for the SOA record. Defaults to 1."
        ttl : "(Optional) The Time To Live of the SOA Record in seconds. Defaults to 3600."
        tags : "(Optional) A mapping of tags to assign to the SOA Record."
      }
    }
  EOT
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
  description = <<EOT
    private_dns_zone_virtual_network_links = {
      name : "(Required) The name of the Private DNS Zone Virtual Network Link. Changing this forces a new resource to be created."
      private_dns_zone_key : "(Required) The key reference to the Private DNS Zone to link."
      virtual_network_id : "(Required) The Resource ID of the Virtual Network that should be linked to the DNS Zone. Changing this forces a new resource to be created."
      registration_enabled : "(Optional) Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled? Defaults to false."
    }
  EOT
  type = map(object({
    name                 = string
    private_dns_zone_key = string
    virtual_network_id   = string
    registration_enabled = optional(bool, false)
  }))
  default = {}
}

variable "private_dns_a_records" {
  description = <<EOT
    private_dns_a_records = {
      name : "(Required) The name of the DNS A Record. Changing this forces a new resource to be created."
      private_dns_zone_key : "(Required) The key reference to the Private DNS Zone where this record should be created."
      ttl : "(Optional) The Time To Live (TTL) of the DNS record in seconds. Defaults to 300."
      records : "(Required) List of IPv4 addresses."
    }
  EOT
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
  description = "(Optional) A mapping of tags to assign to all resources created by this module."
  type        = map(string)
} 