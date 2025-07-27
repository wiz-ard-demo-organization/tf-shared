variable "key" {
  type        = string
  default     = null
  description = "Data source to access the configurations of the Azurerm provider"
}

variable "settings" {
  type        = any
  default     = {}
  description = "Provides the configuration values for the specific resources being deployed"
}

variable "global_settings" {
  type        = any
  default     = null
  description = "Identifies the specific resource instance being deployed"
}

variable "client_config" {
  type        = any
  default     = null
  description = "Global configurations for the Azure Landing Zone"
}

variable "remote_states" {
  type        = any
  default     = {}
  description = "Outputs from the previous deployments that are stored in additional Terraform State Files"
}

variable "resource_groups" {
  type        = any
  default     = {}
  description = "Resource Groups created and being referenced with an Instance key"
}

variable "virtual_networks" {
  type        = any
  default     = {}
  description = "Virtual Networks created and being referenced with an Instance key"
}

variable "network_security_groups" {
  type        = any
  default     = {}
  description = "Network Security Groups created and being referenced with an Instance key"
}

variable "route_tables" {
  type        = any
  default     = {}
  description = "Route tables created and being referenced with an Instance key"
}

variable "subnets" {
  type        = any
  default     = {}
  description = "Subnets created and being referenced with an Instance key"
}
