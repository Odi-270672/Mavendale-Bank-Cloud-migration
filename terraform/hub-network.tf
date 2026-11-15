resource "azurerm_virtual_network" "mavendale_hub_vnet" {
  name                = "vnet-mavendale-hub-dev-uks"
  address_space       = ["10.20.0.0/16"]
  location            = azurerm_resource_group.mavendale_dev.location
  resource_group_name = azurerm_resource_group.mavendale_dev.name
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.mavendale_dev.name
  virtual_network_name = azurerm_virtual_network.mavendale_hub_vnet.name
  address_prefixes     = ["10.20.0.0/26"]

}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.mavendale_dev.name
  virtual_network_name = azurerm_virtual_network.mavendale_hub_vnet.name
  address_prefixes     = ["10.20.1.0/27"]

}