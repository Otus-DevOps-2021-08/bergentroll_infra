resource "local_file" "inventory" {
  content = templatefile(
    "${path.module}/files/inventory.tpl",
    {
      db_hosts  = var.db_hosts
      app_hosts = var.app_hosts
    }
  )
  filename = "${var.output_dir}/inventory"
}

resource "local_file" "inventory_json" {
  content = jsonencode(
    {
      "app" = {
        "hosts" = {
          for host, ip in var.app_hosts :
          host => { "ansible_host" : ip }
        }
      },
      "db" = {
        "hosts" = {
          for host, ip in var.db_hosts :
          host => { "ansible_host" : ip }
        }
      }
    }
  )
  filename = "${var.output_dir}/inventory.json"
}

resource "local_file" "ssh_config" {
  content = templatefile(
    "${path.module}/files/ssh_config.tpl",
    {
      db_hosts  = var.db_hosts
      app_hosts = var.app_hosts
    }
  )
  filename = "${var.output_dir}/ssh_config"
}
