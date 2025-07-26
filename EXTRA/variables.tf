variable "nonprod_subscription_id" {
  type = string
}

variable "prod_subscription_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "log_analytics_workspaces" {
  type = any
}

variable "global_settings" {
  type = any
}

variable "tags" {
  type = any
} 