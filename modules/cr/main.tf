resource "azurerm_container_registry" "acr" {
  name                = "cr${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  admin_enabled       = false
}
