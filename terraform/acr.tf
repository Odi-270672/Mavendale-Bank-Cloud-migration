resource "azurerm_container_registry" "acr" {
  name                = "acrmavendaledevuks"
  resource_group_name = azurerm_resource_group.mavendale_dev.name
  location            = azurerm_resource_group.mavendale_dev.location
  sku                 = "Basic"
  admin_enabled       = false
}