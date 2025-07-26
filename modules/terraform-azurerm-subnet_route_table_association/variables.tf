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

variable "association" {
  description = <<EOT
    association = {
      subnet_id : "(Required) The ID of the Subnet. Changing this forces a new resource to be created."
      route_table_id : "(Required) The ID of the Route Table which should be associated with the Subnet. Changing this forces a new resource to be created."
    }
  EOT
  type = object({
    subnet_id      = string
    route_table_id = string
  })
} 