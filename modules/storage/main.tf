resource "azurerm_storage_account" "default" {
  name                          = "st${var.workload}1234"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  account_kind                  = "StorageV2"
  enable_https_traffic_only     = true
  min_tls_version               = "TLS1_2"
  public_network_access_enabled = true
}

resource "azurerm_storage_share" "file_share" {
  name                 = "share"
  storage_account_name = azurerm_storage_account.default.name
  quota                = 50
}
