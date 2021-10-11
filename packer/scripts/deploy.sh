#! /bin/bash

set -ev

apt-get update -y
apt-get install -y git

pushd /srv/
git clone -b monolith https://github.com/express42/reddit.git

pushd reddit/
bundle install

mv /tmp/reddit.service /etc/systemd/system
systemctl daemon-reload
systemctl enable --now reddit
