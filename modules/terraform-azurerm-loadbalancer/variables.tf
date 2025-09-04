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

variable "public_ips" {
  type        = any
  default     = {}
  description = "Public IP addresses previously created and being referenced with an Instance key"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
} 