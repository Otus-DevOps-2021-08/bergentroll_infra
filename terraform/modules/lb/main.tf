data "yandex_compute_instance" "app" {
  count       = length(var.compute_instance_ids)
  instance_id = var.compute_instance_ids[count.index]
}

resource "yandex_lb_target_group" "app_target_group" {
  name = "${var.name_prefix}reddit-app-target-group"

  dynamic "target" {
    for_each = data.yandex_compute_instance.app
    content {
      subnet_id = var.subnet_id
      address   = target.value.network_interface[0].ip_address
    }
  }
}

resource "yandex_lb_network_load_balancer" "app_lb" {
  name = "${var.name_prefix}reddit-app-lb-tf"

  listener {
    name        = "app-listener"
    port        = var.load_balancer_port
    target_port = var.puma_port
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.app_target_group.id

    healthcheck {
      name = "app-healthcheck"
      http_options {
        port = var.puma_port
        path = "/"
      }
    }
  }

  depends_on = [
    yandex_lb_target_group.app_target_group
  ]
}
