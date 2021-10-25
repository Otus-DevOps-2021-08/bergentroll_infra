locals {
  name_prefix = "stage-"
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "app" {
  source           = "../modules/app/"
  folder_id        = var.folder_id
  instance_num     = var.app_instance_num
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  app_disk_image   = var.app_disk_image
  subnet_id        = module.vpc.subnet_id
  puma_port        = var.puma_port
  db_ip            = module.db.internal_ip_address
  name_prefix      = local.name_prefix
  deploy           = var.deploy
}

module "db" {
  source           = "../modules/db/"
  folder_id        = var.folder_id
  public_key_path  = var.public_key_path
  private_key_path = var.public_key_path
  db_disk_image    = var.db_disk_image
  subnet_id        = module.vpc.subnet_id
  name_prefix      = local.name_prefix
}

module "vpc" {
  source      = "../modules/vpc/"
  folder_id   = var.folder_id
  zone        = var.zone
  name_prefix = local.name_prefix
  cidr_blocks = ["192.168.11.0/24"]
}

module "lb" {
  source               = "../modules/lb/"
  subnet_id            = module.vpc.subnet_id
  puma_port            = var.puma_port
  compute_instance_ids = module.app.compute_instance_ids
  name_prefix          = local.name_prefix
}

module "inventory" {
  source     = "../modules/inventory/"
  db_hosts   = { "${module.db.instance_name}" = module.db.internal_ip_address }
  app_hosts  = module.app.external_ip_address
  output_dir = "../../ansible/"
}
