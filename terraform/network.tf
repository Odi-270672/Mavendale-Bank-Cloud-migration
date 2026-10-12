resource "azurerm_virtual_network" "mavendale_vnet" {
  name          = "vnet-mavendale-dev-uks"
  address_space = ["10.10.0.0/16"]

  location            = azurerm_resource_group.mavendale_dev.location
  resource_group_name = azurerm_resource_group.mavendale_dev.name


  tags = {
    Project     = "Mavendale Bank"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_subnet" "web" {
  name                 = "snet-mavendale-web-dev-uks"
  resource_group_name  = azurerm_resource_group.mavendale_dev.name
  virtual_network_name = azurerm_virtual_network.mavendale_vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}

resource "azurerm_subnet" "app" {
  name                 = "snet-mavendale-app-dev-uks"
  resource_group_name  = azurerm_resource_group.mavendale_dev.name
  virtual_network_name = azurerm_virtual_network.mavendale_vnet.name
  address_prefixes     = ["10.10.2.0/24"]
}

resource "azurerm_subnet" "db" {
  name                 = "snet-mavendale-db-dev-uks"
  resource_group_name  = azurerm_resource_group.mavendale_dev.name
  virtual_network_name = azurerm_virtual_network.mavendale_vnet.name
  address_prefixes     = ["10.10.3.0/24"]
}

resource "azurerm_subnet" "management" {
  name                 = "snet-mavendale-mgmt-dev-uks"
  resource_group_name  = azurerm_resource_group.mavendale_dev.name
  virtual_network_name = azurerm_virtual_network.mavendale_vnet.name
  address_prefixes     = ["10.10.4.0/24"]
}