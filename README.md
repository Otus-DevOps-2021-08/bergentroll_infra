# bergentroll_infra

## Description

Infra repository for bergentroll's DevOps course homeworks.

## Connection through bastion host

With jump

```bash
ssh -i PATH_TO_KEY -J appuser@BASTION_IP appuser@SOMEINTERNALHOST_IP
```

Or with ssh config
```config
# ~/.ssh/config

Host bastion
  User appuser
  IdentityFile PATH_TO_KEY
  Hostname BASTION_IP

Host someinternalhost
  ProxyJump bastion
  User appuser
  Hostname SOMEINTERNALHOST_IP
```

## Bastion Pritunl server

Cause of missing official Pritunl packages for Ubuntu 16.04 bastion host has
been rerolled with Ubuntu 20.04.

```
bastion_IP = 178.154.221.192
someinternalhost_IP = 10.128.0.12
```

sslip.io bastion hostname is https://178.154.221.192.sslip.io/.

# Cloud testapp

`yc` cli is proprietary 😔

```
testapp_IP = 178.154.221.235
testapp_port =  9292
```

Command to run instance:

```bash
yc compute instance create \
  --zone ru-central1-a \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4,nat-address='178.154.221.235' \
  --metadata serial-port-enable=1 \
  --metadata-from-file user-data=./reddit-metadata.yml
```

## Packer

What have been done:
- Meet all HW requirements
- Drink tea
- Get tired

## Terraform

Terraform config has been created. It kicks up multiple app hosts and a load
balancer.

> **TODO**: add bastion host and make nat address block conditional.

> **DRAWBACK**: Changing var.puma_port after provisioning does now update
> running service!

Config with hardcoded multiple similar resources seams fragile and needs to
carefully handle changes in multiple places.

## Terraform 2

DONE:
- Split instance to DB-host and app instances
- Separate Terraform modules
- Stage and prod environment dirs
- Remote S3 object state files (init with `terrafrom init
  -backend-config="access_key=ACCESS_KEY"
  -backend-config="secret_key=SECRET_KEY"`)
- Drive a car for the first time

TODO:
- ~~Fix application provisioning~~
- ~~Manager interhost connection~~
- ~~Return load balancer provisioning~~
- ~~Remote state file~~
- ~~Environments [prod, dev]~~

## Ansible 1

Dynamic inventory output uses simpe format with arrays of hosts binded to
groups. Optionally may be provided dictionary of host variables.

Has been implemented [dynamic_inventory.py](ansible/dynamic_inventory.py)
script to get data in `--list` and `--host NAME` formats from static
`inventory.json`.

## Ansible 2

`yac_inventory.py` implements dynamic inventory script to obtain application
hosts from YAC by instance name. It supports iventory with jump ("bastion") host
config. See `yac_inventory_conf.yml.example` (config file is expected to have
the `yac_inventory_conf.yml` name).

What is done:
- All required variants of Ansible playbooks
- Switch Packer from shell provisioner to Ansible.
Actually it was tricky due to dpkg lock issue. It has been resolved with package
refresh flag which makes Ansible do few retries.
- Nice custom `yac_inventory.py` for dynamic inventory from YAC

FIXME:
- Terraform provisioned db port is inconsistent with playbook

## Ansible 3

I did this task so long so I forgot what I actually did.

- All boring Ansible stuff moving is done
- Dynamic inventory is working
- GitHub Actions validation is here now! Get the nice bage now and get a 150%
cashback!

![bage](https://github.com/Otus-DevOps-2021-08/bergentroll_infra/actions/workflows/validate.yml/badge.svg)

## Ansible 4

I forgot to copy `vault.key` to my laptop, so `credentials.yml` files are
renewed. New key is a symlink to synced file.

Nota bene:
- libvirt provider is used for Vagrant by default
- `generic/ubuntu1604` box is used for Vagrant
