variable "workload" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
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

variable "acr_id" {
  type = string
}

variable "acr_login_server" {
  type = string
}
