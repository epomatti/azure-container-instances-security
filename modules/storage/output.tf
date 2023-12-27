output "id" {
  value = azurerm_storage_account.default.id
}

output "storage_account_name" {
  value = azurerm_storage_account.default.name
}

output "primary_access_key" {
  value     = azurerm_storage_account.default.primary_access_key
  sensitive = true
}

output "share_name" {
  value = azurerm_storage_share.file_share.name
}
