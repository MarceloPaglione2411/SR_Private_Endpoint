terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.12.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}