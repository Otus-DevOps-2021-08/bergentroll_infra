#! /bin/bash

yc compute instance create \
  --zone ru-central1-a \
  --name reddit-bake-app \
  --hostname reddit-bake-app \
  --memory=4 \
  --create-boot-disk image-family=reddit-full,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --ssh-key ~/.ssh/appuser_rsa \
  --metadata serial-port-enable=1
