terraform {
  required_version = ">= 1.5"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.85"
    }
  }

  # Backend configuration will be provided by GitHub Actions
  # backend "azurerm" {
  #   resource_group_name  = "rg-terraform-state"
  #   storage_account_name = "tfstateXXXXX"
  #   container_name       = "tfstate"
  #   key                  = "tf-plat-management.tfstate"
  # }
}

# Default provider for nonprod subscription
provider "azurerm" {
  features {}
  subscription_id = var.nonprod_subscription_id
}

# Provider alias for production subscription
provider "azurerm" {
  alias = "prod"
  features {}
  subscription_id = var.prod_subscription_id
} 