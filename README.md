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

Config with hardcoded multiple similar resources seams fragile and needs to
carefully handle changes in multiple places.
