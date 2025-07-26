terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_subnet_route_table_association" "this" {
  subnet_id      = var.association.subnet_id
  route_table_id = var.association.route_table_id
} 