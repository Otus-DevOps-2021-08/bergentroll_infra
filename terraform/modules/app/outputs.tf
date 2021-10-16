output "external_ip_address" {
  description = "Assigned instance IPv4 address"
  value = [
    for i in yandex_compute_instance.app :
    "${i.name}: ${i.network_interface[0].nat_ip_address}"
  ]
}

output "image_name" {
  description = "Name of image used to set up hosts"
  value       = data.yandex_compute_image.app_image.name
}
