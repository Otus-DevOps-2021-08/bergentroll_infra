locals {
  listener    = tolist(yandex_lb_network_load_balancer.app_lb.listener)[0]
  listener_ip = tolist(local.listener.external_address_spec)[0].address
}

output "hosts_ip_addresses" {
  description = "Assigned instance IPv4 address"
  value = [
    for i in yandex_compute_instance.app :
    "${i.name}: ${i.network_interface[0].nat_ip_address}"
  ]
}

output "external_ip_address_app" {
  description = "Assigned instance IPv4 address"
  value       = local.listener_ip
}

output "app_link" {
  description = "Application URL"
  value       = "http://${local.listener_ip}:${var.load_balancer_port}"
}
