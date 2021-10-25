# Spied in the repo of @vlyulin
locals {
  instance_ip_list     = yandex_compute_instance.app[*].network_interface[0].nat_ip_address
  provisioning_ip_list = var.deploy ? local.instance_ip_list : []
  provisioning_ip_set  = toset(local.provisioning_ip_list)
}

data "yandex_compute_image" "app_image" {
  family    = var.app_disk_image
  folder_id = var.folder_id
}

resource "yandex_compute_instance" "app" {
  count                     = var.instance_num
  name                      = "${var.name_prefix}reddit-app-tf-${count.index}"
  platform_id               = "standard-v2"
  allow_stopping_for_update = true

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}}"
  }

  resources {
    cores         = 2
    core_fraction = 5
    memory        = 1
  }

  boot_disk {
    initialize_params { image_id = data.yandex_compute_image.app_image.id }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }
}

resource "null_resource" "deploy" {
  count = length(local.provisioning_ip_list)

  connection {
    type        = "ssh"
    host        = local.provisioning_ip_list[count.index]
    user        = "ubuntu"
    agent       = false
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    content = templatefile(
      "${path.module}/files/puma.service",
      {
        puma_port = var.puma_port
        db_ip     = var.db_ip
      }
    )
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }
}
