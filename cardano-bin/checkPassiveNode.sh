#!/bin/bash

export CARDANO_NODE_SOCKET_PATH=/home/cardano/passive/node.socket
export PATH=$PATH:/usr/share/cardano

systemctl status cardano-passive | cat
cardano-cli --version
cardano-cli query tip --mainnet
