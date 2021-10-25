data "yandex_compute_image" "db_image" {
  family    = var.db_disk_image
  folder_id = var.folder_id
}

resource "yandex_compute_instance" "db" {
  name                      = "${var.name_prefix}reddit-db-tf"
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
    initialize_params { image_id = data.yandex_compute_image.db_image.id }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = false
  }
}
