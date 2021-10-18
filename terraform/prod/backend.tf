terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    region   = "us-east-1"

    bucket = "bergentroll-otus"
    key    = "cloud-testapp/prod.tfstate"

    skip_credentials_validation = true
    skip_region_validation      = true

    # Please, init access_key and secret_key values with -backed-config
    # command line option.
  }
}
