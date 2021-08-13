#!/bin/bash

export CARDANO_NODE_PATH=/home/cardano/passive
export CARDANO_NODE_SOCKET_PATH=$CARDANO_NODE_PATH/node.socket
export PATH=$PATH:/usr/share/cardano

systemctl status cardano-passive | cat
cardano-cli --version

online=1
cardano-cli query tip --mainnet || online=0
if [[ $online -eq 1 ]]
then
  json=`cardano-cli query tip --mainnet`
  echo $json > $CARDANO_NODE_PATH/logs/current_tip.log
fi

echo
echo

free -mh
