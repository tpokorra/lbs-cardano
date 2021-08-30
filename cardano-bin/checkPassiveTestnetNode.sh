#!/bin/bash

export CARDANO_NODE_PATH=/home/cardano/passive-testnet
export CARDANO_NODE_SOCKET_PATH=$CARDANO_NODE_PATH/node.socket
export PATH=$PATH:/usr/share/cardano

systemctl status cardano-passive-testnet | cat
cardano-cli --version

online=1
cardano-cli query tip --testnet || online=0
if [[ $online -eq 1 ]]
then
  json=`cardano-cli query tip --testnet`
  echo $json > $CARDANO_NODE_PATH/logs/current_tip.log
fi

echo
echo

free -mh
