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

variable "image_id" {}

variable "subnet_id" {}

variable "service_account_key_file" {
  default = null
}
