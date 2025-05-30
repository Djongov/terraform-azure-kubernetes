# The creation of a vnet by this module is optional. It is based on whether var.vnet_subnet_id is set or not.
resource "azurerm_virtual_network" "this" {
  count               = var.vnet_subnet_id == null ? 1 : 0
  name                = "${var.project_name}-k8s-vnet"
  address_space       = ["10.42.0.0/25"] # This provides us with 128 IP addresses
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.common_tags
}

# now the subnet
resource "azurerm_subnet" "this" {
  count                = var.vnet_subnet_id == null ? 1 : 0
  name                 = "k8s-workload"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[0].name
  address_prefixes     = ["10.42.0.0/26"] # This provides us with 64 IP addresses, which in overlay k8s clusters means 61 nodes

  depends_on = [azurerm_virtual_network.this]
}
