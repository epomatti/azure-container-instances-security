output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "containers_subnet_id" {
  value = azurerm_subnet.containers.id
}

output "app_gateway_subnet_id" {
  value = azurerm_subnet.app_gateway.id
}
