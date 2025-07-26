# ===================================
# Local Values for Resource Management
# ===================================

locals {
  # Merge tags from variables
  merged_tags = var.tags
}

# ===================================
# Centralized Log Analytics Workspace
# ===================================

module "log_analytics_workspace" {
  source = "../tf-shared/modules/terraform-azurerm-log_analytics_workspace"

  key             = "central-law"
  global_settings = var.global_settings

  log_analytics_workspace = var.log_analytics_workspaces.central_workspace
  
  tags = local.merged_tags
} 