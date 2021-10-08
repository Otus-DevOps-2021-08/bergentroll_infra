#! /bin/bash

# Exit on first fail
set -e

apt-get update -y
apt-get install git

git clone -b monolith https://github.com/express42/reddit.git

pushd reddit

bundle install

puma -d

# Echo socket info
pgrep -af puma
