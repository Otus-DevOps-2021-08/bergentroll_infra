data "yandex_compute_image" "app_image" {
  family    = var.app_disk_image
  folder_id = var.folder_id
}

resource "yandex_compute_instance" "app" {
  count                     = var.instance_num
  name                      = "reddit-app-tf-${count.index}"
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

  connection {
    type        = "ssh"
    host        = self.network_interface[0].nat_ip_address
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
