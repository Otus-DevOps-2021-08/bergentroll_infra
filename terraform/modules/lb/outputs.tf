locals {
  listener    = tolist(yandex_lb_network_load_balancer.app_lb.listener)[0]
  listener_ip = tolist(local.listener.external_address_spec)[0].address
}

output "listener_ip" {
  value = local.listener_ip
}

output "app_url" {
  description = "Application URL"
  value       = "http://${local.listener_ip}:${var.load_balancer_port}"
}
