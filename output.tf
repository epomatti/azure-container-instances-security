output "app_gateway_public_ip_address" {
  value = var.create_containers ? module.app_gateway[0].public_ip_address : null
}
