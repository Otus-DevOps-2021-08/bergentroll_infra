#! /bin/bash

# Exit on first fail
set -e

if [ "$EUID" -ne 0 ]; then
  1>&2 echo 'root permissions required'
  exit 1
fi

apt-get update -y
apt-get install -y git

pushd /srv/
git clone -b monolith https://github.com/express42/reddit.git

pushd reddit/
bundle install

puma -d

# Echo socket info
pgrep -af puma
