#! /bin/bash

set -e

while pgrep -af 'dpkg|apt-get'; do
  echo 'Waiting pkg manager'
  sleep 1
done
