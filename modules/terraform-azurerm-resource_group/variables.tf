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

variable "resource_group" {
  description = <<EOT
    resource_group = {
      name : "(Optional) The name of the resource group. If not provided, will be generated using naming module."
      location : "(Required) The Azure Region where the resource group should exist."
    }
  EOT
  type = object({
    name     = optional(string)
    location = string
  })
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource group."
  type        = map(string)
  default     = {}
} 