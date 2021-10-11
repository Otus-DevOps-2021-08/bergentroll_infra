#! /bin/bash

# Exit on first fail
set -e

if [ "$EUID" -ne 0 ]; then
  1>&2 echo 'root permissions required'
  exit 1
fi

apt-get update
apt-get upgrade -y
apt-get install -y ruby-full ruby-bundler build-essential
