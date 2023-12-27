resource "azurerm_container_group" "main" {
  name                = "ci-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type = "Linux"
  sku     = var.ci_sku

  ip_address_type = "Private"
  subnet_ids      = [var.subnet_id]

  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = var.ci_cpu
    memory = var.ci_memory

    ports {
      port     = 8080
      protocol = "TCP"
    }
  }

}
