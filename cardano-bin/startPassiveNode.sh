#!/bin/bash

BINDIP=0.0.0.0
PUBLICPORT="3001"
CONFPATH="/home/cardano/passive"
PATH=$PATH:/usr/share/cardano

cardano-node run \
   --topology $CONFPATH/mainnet-topology.json \
   --database-path $CONFPATH/db \
   --socket-path $CONFPATH/node.socket \
   --host-addr $BINDIP \
   --port $PUBLICPORT \
   --config $CONFPATH/mainnet-config.json
