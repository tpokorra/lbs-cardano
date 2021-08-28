#!/usr/bin/python3

# apt-get install python3 python3-requests

import requests
import subprocess
import os
import json

bashCmd = ["cardano-cli", "query", "tip", "--mainnet"]
nodePath = "/home/cardano/passive"
my_env = {'CARDANO_NODE_PATH': nodePath, 'CARDANO_NODE_SOCKET_PATH': nodePath+'/node.socket', 'PATH': os.environ['PATH']+':/usr/share/cardano'}
process = subprocess.Popen(bashCmd, stdout=subprocess.PIPE, env=my_env)

output, error = process.communicate()
mynode = json.loads(output)
print("my node: ")
print("  epoch: {0}".format(mynode['epoch']))
print("  block: {0}".format(mynode['block']))

response = requests.get("https://api.blockchair.com/cardano/stats/")

if response.status_code == 200:
  #print(response.json())
  check = response.json()['data']
  print("check node:")
  print("  epoch: {0}".format(check['best_block_epoch']))
  print("  block: {0}".format(check['best_block_height']))
  print("  time:  {0}".format(check['best_block_time']))

if check['best_block_epoch'] == mynode['epoch']:
    if mynode['block'] - check['best_block_height'] <= 10:
        print("my node is uptodate")
        exit()

print("my node is not uptodate")
exit(-1)

