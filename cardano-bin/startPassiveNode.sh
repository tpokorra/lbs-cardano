#!/bin/bash

BINDIP=0.0.0.0
PUBLICPORT="3001"
CONFPATH="/home/cardano/passive"
PATH=$PATH:/usr/share/cardano

if [ ! -d $CONFPATH ]; then
    mkdir -p $CONFPATH
    cd $CONFPATH
    wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-config.json
    wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-byron-genesis.json
    wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-shelley-genesis.json
    wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-alonzo-genesis.json
    wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-topology.json
    cd -
fi

# +RTS -N2 --disable-delayed-os-memory-return -I0.3 -Iw600 -A16m -F1.5 -H2500M -T -S -RTS \
cardano-node run \
   --topology $CONFPATH/mainnet-topology.json \
   --database-path $CONFPATH/db \
   --socket-path $CONFPATH/node.socket \
   --host-addr $BINDIP \
   --port $PUBLICPORT \
   --config $CONFPATH/mainnet-config.json
