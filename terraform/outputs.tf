# TODO
#locals {
#  listener    = tolist(yandex_lb_network_load_balancer.app_lb.listener)[0]
#  listener_ip = tolist(local.listener.external_address_spec)[0].address
#}

output "external_ip_address_app" {
  description = "Assigned instance IPv4 address"
  value = [
    for i in yandex_compute_instance.app :
    "${i.name}: ${i.network_interface[0].nat_ip_address}"
  ]
}

output "external_ip_address_db" {
  description = "Assigned instance IPv4 address"
  value = [
    for i in yandex_compute_instance.db :
    "${i.name}: ${i.network_interface[0].nat_ip_address}"
  ]
}

output "app_image" {
  value = data.yandex_compute_image.app_image.name
}

output "db_image" {
  value = data.yandex_compute_image.db_image.name
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
