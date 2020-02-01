#!/usr/bin/env bash

# shell is funny

set -e

function run_eth() {
    if [[ ${1} ]];then
        geth init  genesis.json
        if [[ $? != 0 ]];then exit;fi
        echo "============= geth init success ============="
    fi

    geth --identity demo \
    --rpc --rpcaddr 0.0.0.0 --rpcapi db,eth,net,web3,personal,miner,admin \
    --ws --wsaddr 0.0.0.0 --wsapi db,eth,net,web3,personal,miner,admin --wsorigins "*"\
    --ipcdisable --nat none --verbosity 3 \
    --allow-insecure-unlock --unlock 0 --password <(echo -n 1234) --mine --minerthreads 1
}

case ${1} in
    -g|geth)
        run_eth ${2};exit;;
    *)
        echo -e "\n`basename ${0}`:Usage: [OPTIONS]\n"
        echo -e "Options:"
        echo -e "\t-g, geth [init] \t\t run block chain"
        exit 1;;
esac