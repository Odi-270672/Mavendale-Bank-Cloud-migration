/* This allows us to grant AKS the necessary network permissions before the cluster is provisioned
It creates a User-Assigned Managed Identity being a standalone identity in Microsoft Entra ID that 
can be assigned to Azure resources, allowing them to authenticate and access other Azure resources 
without using passwords or stored credentials.
*/
resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "id-mavendale-aks-dev-uks"
  location            = azurerm_resource_group.mavendale_dev.location
  resource_group_name = azurerm_resource_group.mavendale_dev.name
}

/*
sku_tier — minimises our AKS management costs.
depends_on — ensures Terraform creates the Network Contributor role assignment before provisioning AKS.
*/
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-mavendale-dev-uks"
  location            = azurerm_resource_group.mavendale_dev.location
  resource_group_name = azurerm_resource_group.mavendale_dev.name
  dns_prefix          = "aks-mavendale-dev-uks"
  sku_tier            = "Free"
  depends_on          = [azurerm_role_assignment.aks_network_contributor]

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.aks.id
    upgrade_settings {
      max_surge                     = "10%"
      drain_timeout_in_minutes      = 0
      node_soak_duration_in_minutes = 0
    }
  }
  # And this block within your AKS cluster resource assigns the above User-Assigned Managed Identity to AKS:

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }
  /* Configure Azure CNI Overlay networking, allowing nodes to receive
   IP addresses from the AKS subnet and pods to receive IP addresses
   from a separate CIDR range, conserving VNet IP addresses.
  */

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
  }

  tags = {
    Project     = "Mavendale Bank"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }

}
# To grant AKS the necessary permissions to manage networking within its dedicated subnet
resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = azurerm_subnet.aks.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id

}
/* To grant the AKS kubelet managed identity permissions to pull container images from our 
ACR without stored credentials
*/
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}