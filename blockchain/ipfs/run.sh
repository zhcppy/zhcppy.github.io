#!/usr/bin/env bash

# shell is funny

set -e

# https://github.com/ipfs/go-ipfs/blob/master/docs/config.md

if [ ! -f conifg ]; then
    echo "ipfs config is no found"; exit 1;
fi

IPFS_DIR=$(pwd)/.ipfs
mkdir -p "${IPFS_DIR}"
echo "export IPFS_PATH=${IPFS_DIR}"
export IPFS_PATH=${IPFS_DIR}
export IPFS_LOGGING="debug"
if [[ ${1} ]]; then
    rm -rf "${IPFS_DIR}"
    ipfs init config
fi
ipfs daemon