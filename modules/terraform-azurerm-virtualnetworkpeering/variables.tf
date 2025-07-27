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

variable "peering" {
  description = <<EOT
    peering = {
      name : "(Required) The name of the virtual network peering. Changing this forces a new resource to be created."
      resource_group_name : "(Required) The name of the resource group in which to create the virtual network peering. Changing this forces a new resource to be created."
      virtual_network_name : "(Required) The name of the virtual network. Changing this forces a new resource to be created."
      remote_virtual_network_id : "(Required) The full Azure resource ID of the remote virtual network. Changing this forces a new resource to be created."
      allow_virtual_network_access : "(Optional) Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to true."
      allow_forwarded_traffic : "(Optional) Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false."
      allow_gateway_transit : "(Optional) Controls gatewayLinks can be used in the remote virtual network's link to the local virtual network. Defaults to false."
      use_remote_gateways : "(Optional) Controls if remote gateways can be used on the local virtual network. If the flag is set to true, and allow_gateway_transit on the remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Defaults to false."
      triggers : "(Optional) A mapping of key values pairs that can be used to sync network gateway route tables used with this peering."
    }
  EOT
  type = object({
    name                         = optional(string)
    resource_group_name          = string
    virtual_network_name         = string
    remote_virtual_network_id    = string
    allow_virtual_network_access = optional(bool)
    allow_forwarded_traffic      = optional(bool)
    allow_gateway_transit        = optional(bool)
    use_remote_gateways          = optional(bool)
    triggers                     = optional(map(string))
  })

  validation {
    condition = !(try(var.peering.allow_gateway_transit, false) && try(var.peering.use_remote_gateways, false))
    error_message = "allow_gateway_transit and use_remote_gateways cannot both be true for the same peering."
  }
} 