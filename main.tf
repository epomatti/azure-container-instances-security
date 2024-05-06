terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.102.0"
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
  sku                 = var.acr_sku
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

  subnet_id                          = module.vnet.containers_subnet_id
  ci_sku                             = var.ci_sku
  ci_cpu                             = var.ci_cpu
  ci_memory                          = var.ci_memory
  acr_id                             = module.cr.id
  acr_login_server                   = module.cr.login_server
  storage_account_name               = module.storage.storage_account_name
  storage_account_primary_access_key = module.storage.primary_access_key
  storage_account_share_name         = module.storage.share_name
}

module "app_gateway" {
  count               = var.create_containers == true ? 1 : 0
  source              = "./modules/appgateway"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  subnet_id           = module.vnet.app_gateway_subnet_id
  ci_ip_address       = module.ci[0].ip_address

  sku_name     = var.agw_sku_name
  sku_tier     = var.agw_sku_tier
  sku_capacity = var.agw_sku_capacity
}
