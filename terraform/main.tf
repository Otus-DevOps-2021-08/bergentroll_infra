terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.64.1"
    }
  }
}

provider "yandex" {
  folder_id = "b1g1c2edoofrofrhbeer"
  zone = "ru-central1-a"
}

resource "yandex_compute_instance" "app" {
  allow_stopping_for_update = true
  name = "reddit-app-tf"
  platform_id = "standard-v2"

  resources {
    cores = 2
    core_fraction = 5
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8l12ucp92to452fbo0"
    }
  }

  network_interface {
    subnet_id = "e9b3vj6sa7i9ebev0icv"
    nat = true
  }
}
