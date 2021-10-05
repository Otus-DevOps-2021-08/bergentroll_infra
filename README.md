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
