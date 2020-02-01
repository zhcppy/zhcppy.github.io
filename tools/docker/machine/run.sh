#!/usr/bin/env bash

# shell is funny

set -e

if [[ ! -f $(which docker-machine) ]]; then
    exho "please install docker-machine or start Desktop Docker"; exit 1
fi

if [[ ! `uname` == "Linux" ]]; then
    echo "pQlease run in Linux"; exit 1
fi

baseUrl=https://github.com/docker/machine/releases/download/v0.16.0
curl -L ${baseUrl}/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine
sudo install /tmp/docker-machine /usr/local/bin/docker-machine
