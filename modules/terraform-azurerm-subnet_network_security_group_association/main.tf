# Module for associating Network Security Groups with Azure subnets to apply network security rules
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Create association between subnet and network security group for traffic filtering
resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = var.association.subnet_id
  network_security_group_id = var.association.network_security_group_id
} 