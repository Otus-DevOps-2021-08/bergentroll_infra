provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "app" {
  source           = "./modules/app"
  folder_id        = var.folder_id
  instance_num     = var.app_instance_num
  public_key_path  = var.public_key_path
  private_key_path = var.public_key_path
  app_disk_image   = var.app_disk_image
  subnet_id        = module.vpc.subnet_id
  puma_port        = var.puma_port
}

module "db" {
  source           = "./modules/db"
  folder_id        = var.folder_id
  public_key_path  = var.public_key_path
  private_key_path = var.public_key_path
  db_disk_image    = var.db_disk_image
  subnet_id        = module.vpc.subnet_id
}

module "vpc" {
  source    = "./modules/vpc"
  folder_id = var.folder_id
  zone      = var.zone
}

# TODO module "lb" {
