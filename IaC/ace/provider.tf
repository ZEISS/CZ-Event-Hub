terraform {
  required_version = ">=1.3.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.32.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "853049fd-4889-45b6-aad9-f3f54421399c"
}

