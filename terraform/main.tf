
resource "azurerm_resource_group" "mavendale_dev" {
  name     = "rg-mavendale-dev-uks"
  location = "uksouth"

  tags = {
    Project     = "Mavendale Bank"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}