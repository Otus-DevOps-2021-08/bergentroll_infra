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
testapp_IP = 178.154.234.144
testapp_port =  9292
```
