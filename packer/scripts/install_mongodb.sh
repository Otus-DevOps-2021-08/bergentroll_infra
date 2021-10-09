#! /bin/bash

set -ev

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y apt-transport-https

# Get MongoDB GPG key
apt-key adv --keyserver hkp://keyserver.ubuntu.com \
  --recv 'E162F504A20CDF15827F718D4B7C549A058F8B6B'

echo \
  "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" |
  tee /etc/apt/sources.list.d/mongodb-org-4.2.list

apt-get update -y
apt-get install -y mongodb-org
systemctl enable --now mongod.service
