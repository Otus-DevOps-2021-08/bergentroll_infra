variable "folder_id" {}

variable "instance_num" {
  description = "Amount of application hosts"
  default     = 1
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

variable "subnet_id" {}

variable "puma_port" { default = 9292 }
