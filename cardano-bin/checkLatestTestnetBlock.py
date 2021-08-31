#!/usr/bin/python3

# apt-get install python3 python3-requests

import requests
import subprocess
import os
import json
import datetime

bashCmd = ["cardano-cli", "query", "tip", "--testnet-magic", "1097911063"]
nodePath = "/home/cardano/passive-testnet"
my_env = {'CARDANO_NODE_PATH': nodePath, 'CARDANO_NODE_SOCKET_PATH': nodePath+'/node.socket', 'PATH': os.environ['PATH']+':/usr/share/cardano'}
process = subprocess.Popen(bashCmd, stdout=subprocess.PIPE, env=my_env)

output, error = process.communicate()
mynode = json.loads(output)
print("<pre>")
print("my node: ")
#print(mynode)
print("  epoch: {0}".format(mynode['epoch']))
print("  block: {0}".format(mynode['block']))
print("  sync:  {0}".format(mynode['syncProgress']))

response = requests.get("https://explorer-api.testnet.dandelion.link/api/blocks/pages")

if response.status_code == 200:
  check = response.json()['Right'][1][0]
  print("check node:")
  print("  epoch: {0}".format(check['cbeEpoch']))
  print("  block: {0}".format(check['cbeBlkHeight']))
  print("  time:  {0}".format(datetime.datetime.utcfromtimestamp(check['cbeTimeIssued']).strftime('%Y-%m-%d %H:%M:%S')))

  if check['cbeEpoch'] == mynode['epoch']:
    if mynode['block'] - check['cbeBlkHeight'] <= 10:
        print("my node is uptodate")
        exit()

if float(mynode['syncProgress']) > 99.0 and float(mynode['syncProgress']) <= 100.0:
  print("my node is uptodate")
  exit()

print("my node is not uptodate")
exit(-1)

