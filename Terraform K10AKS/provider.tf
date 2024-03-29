# Define Terraform provider
terraform {
  required_version = "~> 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.94.0"
    }
  }
}

# Configure the Azure provider
provider "azurerm" { 
  features {}  
}
