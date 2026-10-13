terraform {
  backend "azurerm" {
    resource_group_name  = "rg-mavendale-tfstate-uks"
    storage_account_name = "stmavendaletfstateuks01"
    container_name       = "tfstate"
    key                  = "mavendale-dev.tfstate"
    use_azuread_auth     = true
  }
}