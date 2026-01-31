terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.58.0"
    }
  }
  backend "azurerm" {

  }
}

provider "azurerm" {
  features {}
  subscription_id = "ad7a29d5-9ccb-4a91-a20e-8d50dc61f5d6"
}








