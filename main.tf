terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.85.0"
    }
  }
}

locals {
  workload = "chokolatte"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.workload}"
  location = var.location
}

module "vnet" {
  source              = "./modules/vnet"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "cr" {
  source              = "./modules/cr"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "storage" {
  source              = "./modules/storage"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "ci" {
  count               = var.create_containers == true ? 1 : 0
  source              = "./modules/ci"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  subnet_id        = module.vnet.containers_subnet_id
  ci_sku           = var.ci_sku
  ci_cpu           = var.ci_cpu
  ci_memory        = var.ci_memory
  acr_id           = module.cr.id
  acr_login_server = module.cr.login_server
}

module "app_gateway" {
  count               = var.create_containers == true ? 1 : 0
  source              = "./modules/appgateway"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  subnet_id           = module.vnet.app_gateway_subnet_id
  ci_ip_address       = module.ci[0].ip_address
}
