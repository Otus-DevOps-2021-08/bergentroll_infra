output "external_ip_address_app" {
  description = "Assigned instance IPv4 address"
  value       = yandex_compute_instance.app.network_interface.0.nat_ip_address
}

output "app_link" {
  description = "Application URL"
  value       = "http://${yandex_compute_instance.app.network_interface.0.nat_ip_address}:9292"
}
