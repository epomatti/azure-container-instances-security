resource "azurerm_container_group" "main" {
  name                = "ci-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type = "Linux"
  sku     = var.ci_sku

  ip_address_type = "Private"
  subnet_ids      = [var.subnet_id]

  container {
    name   = "app"
    image  = "${var.acr_login_server}/app:latest"
    cpu    = var.ci_cpu
    memory = var.ci_memory

    # security {
    #   privilege_enabled = false
    # }

    ports {
      port     = 8080
      protocol = "TCP"
    }

    volume {
      name                 = "share"
      mount_path           = "/mnt/share"
      storage_account_name = var.storage_account_name
      storage_account_key  = var.storage_account_primary_access_key
      share_name           = var.storage_account_share_name
    }
  }

  image_registry_credential {
    user_assigned_identity_id = azurerm_user_assigned_identity.ci.id
    server                    = var.acr_login_server
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.ci.id,
    ]
  }

  depends_on = [azurerm_role_assignment.acr]
}

resource "azurerm_user_assigned_identity" "ci" {
  name                = "ci-identity"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "acr" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.ci.principal_id
}
