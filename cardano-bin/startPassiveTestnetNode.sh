#!/bin/bash

BINDIP=0.0.0.0
PUBLICPORT="3001"
CONFPATH="/home/cardano/passive-testnet"
PATH=$PATH:/usr/share/cardano

if [ ! -d $CONFPATH ]; then
    mkdir -p $CONFPATH
    cd $CONFPATH
    wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/testnet-config.json
    wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/testnet-byron-genesis.json
    wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/testnet-shelley-genesis.json
    wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/testnet-alonzo-genesis.json
    wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/testnet-topology.json
    cd -
fi

# +RTS -N2 --disable-delayed-os-memory-return -I0.3 -Iw600 -A16m -F1.5 -H2500M -T -S -RTS \
cardano-node run \
   --topology $CONFPATH/testnet-topology.json \
   --database-path $CONFPATH/db \
   --socket-path $CONFPATH/node.socket \
   --host-addr $BINDIP \
   --port $PUBLICPORT \
   --config $CONFPATH/testnet-config.json
