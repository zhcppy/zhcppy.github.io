#!/usr/bin/env bash

# shell is funny

set -e

if [[ ! -f $(which go 2>/dev/null) ]]; then
    echo "Please install Golang and set GOPATH directory";exit -1
fi

if [[ ! $GOPATH ]]; then
    echo "Please set you GOPATH directory"
fi

if [[ ! -d $GOPATH/src/github.com/hyperledger/fabric ]]; then
    go get -v github.com/hyperledger/fabric
fi


if [[ ! -d $GOPATH/src/github.com/hyperledger/fabric-ca ]]; then
    go get -v github.com/hyperledger/fabric-ca
fi

brew install gnu-tar

echo 'PATH="$PATH:/usr/local/opt/gnu-tar/libexec/gnubin"' >> ~/.zshrc

source ~/.zshrc

cd $GOPATH/src/github.com/hyperledger/fabric
make

cd $GOPATH/src/github.com/hyperledger/fabric-ca
make