variable "location" {
  type = string
}

variable "acr_sku" {
  type = string
}

variable "create_containers" {
  type = bool
}

variable "ci_sku" {
  type = string
}

variable "ci_cpu" {
  type = number
}

variable "ci_memory" {
  type = number
}

# Application Gateway
variable "agw_sku_name" {
  type = string
}

variable "agw_sku_tier" {
  type = string
}

variable "agw_sku_capacity" {
  type = string
}
