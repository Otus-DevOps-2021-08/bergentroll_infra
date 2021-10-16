variable "cloud_id" { default = null }

variable "folder_id" {}

variable "zone" {
  default = "ru-central1-a"
}

variable "public_key_path" {
  description = "Path to the public key used for SSH access"
}

variable "private_key_path" {
  description = "Path to the private key used for SSH access"
}

variable "app_disk_image" {
  description = "Reddit application runtime image"
  default     = "reddit-ruby"
}

variable "db_disk_image" {
  description = "Reddit application database image"
  default     = "reddit-db"
}

variable "service_account_key_file" {
  default = null
}

variable "instance_num" {
  description = "Amount of application hosts"
  default     = 1
}

variable "puma_port" {
  description = "Port to bind the Puma server"
  default     = 9292
}

variable "load_balancer_port" {
  description = "Port to expose an application"
  default     = 80
}
