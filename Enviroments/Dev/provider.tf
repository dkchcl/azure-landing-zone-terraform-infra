terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.58.0"
    }
  }
  # backend "azurerm" {

  # }
}

provider "azurerm" {
  features {}
  subscription_id = "0f7f8841-a8e1-461b-a942-3270381f454c"
  # subscription_id = "b14a3699-29f5-4013-af1a-5ee5bcc0c511"
}








