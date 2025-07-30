variable "key" {
  description = "Unique identifier for the resource"
  type        = string
}

variable "settings" {
  description = "Configuration settings for the Key Vault"
  type        = any
}

variable "global_settings" {
  description = "Global settings passed from the root module"
  type        = any
}

variable "client_config" {
  description = "Client configuration from data source"
  type        = any
}

variable "resource_groups" {
  description = "Resource groups map"
  type        = any
  default     = {}
}

variable "remote_states" {
  description = "Remote state data for cross-state references"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Additional tags to apply to the resource"
  type        = map(string)
  default     = {}
} 