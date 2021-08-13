#!/bin/bash

BINDIP=0.0.0.0
PUBLICPORT="3001"
CONFPATH="/home/cardano/passive"
PATH=$PATH:/usr/share/cardano

cardano-node run \
   +RTS -N2 --disable-delayed-os-memory-return -I0.3 -Iw600 -A16m -F1.5 -H2500M -T -S -RTS \
   --topology $CONFPATH/mainnet-topology.json \
   --database-path $CONFPATH/db \
   --socket-path $CONFPATH/node.socket \
   --host-addr $BINDIP \
   --port $PUBLICPORT \
   --config $CONFPATH/mainnet-config.json
