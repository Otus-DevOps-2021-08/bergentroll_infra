variable "folder_id" {}

variable "public_key_path" {
  description = "Path to the public key used for SSH access"
}

variable "private_key_path" {
  description = "Path to the private key used for SSH access"
}

variable "db_disk_image" {
  description = "Reddit application database image"
  default     = "reddit-db"
}

variable "subnet_id" {}

variable "name_prefix" { default = "" }
