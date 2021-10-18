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

output "load_balancer_ip" {
  description = "Load balancer IPv4"
  value       = module.lb.listener_ip
}

output "app_url" {
  description = "Application URL"
  value       = module.lb.app_url
}
