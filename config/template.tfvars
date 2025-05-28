# General
subscription_id = "your-subscription-id"
location        = "eastus2"

# Container Registry
acr_sku           = "Premium"
acr_admin_enabled = true

# Container Instances
create_containers = false
ci_sku            = "Standard"
ci_cpu            = 2
ci_memory         = 4

# Application Gateway
agw_sku_name     = "Standard_v2"
agw_sku_tier     = "Standard_v2"
agw_sku_capacity = 1
