#! /bin/bash

set -ev

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade -y
apt-get install -y ruby-full ruby-bundler build-essential
