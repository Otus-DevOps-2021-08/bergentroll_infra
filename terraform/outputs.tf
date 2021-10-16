# TODO
#locals {
#  listener    = tolist(yandex_lb_network_load_balancer.app_lb.listener)[0]
#  listener_ip = tolist(local.listener.external_address_spec)[0].address
#}

output "external_ip_address_app" {
  description = "Assigned instance application IPv4 address"
  value       = module.app.external_ip_address
}

output "external_ip_address_db" {
  description = "Assigned instance database IPv4 address" # TODO
  value       = module.db.external_ip_address
}

output "app_image" {
  value = module.app.image_name
}

output "db_image" {
  value = module.db.image_name
}

# TODO
#output "external_ip_address_app" {
#  description = "Assigned instance IPv4 address"
#  value       = local.listener_ip
#}

# TODO
#output "app_link" {
#  description = "Application URL"
#  value       = "http://${local.listener_ip}:${var.load_balancer_port}"
#}
