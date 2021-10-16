# We does not create a new network due to quota
data "yandex_vpc_network" "app-network" {
  name      = "default"
  folder_id = var.folder_id
}

resource "yandex_vpc_subnet" "app-subnet" {
  name           = "reddit-app-subnet"
  description    = "Private network for Otus Reddit application"
  zone           = var.zone
  network_id     = data.yandex_vpc_network.app-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
