#! /bin/bash

set -ev

sudo apt-get update -y
sudo apt-get install -y git

pushd /srv/
sudo git clone -b monolith https://github.com/express42/reddit.git

sudo useradd --system --home-dir /srv/reddit/ puma
sudo chown puma:puma reddit/ -R

pushd reddit/
sudo bundle install

sudo mv /tmp/puma.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now puma
