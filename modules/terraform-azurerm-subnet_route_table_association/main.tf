# Module for associating Route Tables with Azure subnets to control network traffic routing
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Create association between subnet and route table for custom routing rules
resource "azurerm_subnet_route_table_association" "this" {
  subnet_id      = var.association.subnet_id
  route_table_id = var.association.route_table_id
} 