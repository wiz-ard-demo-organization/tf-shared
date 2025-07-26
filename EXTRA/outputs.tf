# ===================================
# Log Analytics Workspace Outputs
# ===================================

output "log_analytics_workspace" {
  description = "Log Analytics Workspace configuration and metadata"
  value       = module.log_analytics_workspace.log_analytics_workspace
  sensitive   = true
}

output "log_analytics_workspace_id" {
  description = "ID of the centralized Log Analytics Workspace"
  value       = module.log_analytics_workspace.log_analytics_workspace.id
} 