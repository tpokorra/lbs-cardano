#!/bin/bash

branch=$1

apt-get -y install rsync curl git sudo xz-utils || exit -1
apt-get -y install gnupg apt-transport-https ca-certificates libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev tmux jq wget libncursesw5 || exit -1
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4796B710919684AC || exit -1
echo 'deb http://downloads.haskell.org/debian buster main' >> /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA3CBA3FFE22B574 || exit -1
apt-get update
apt-get -y install libsodium-dev libsecp256k1-dev || exit -1
# see http://downloads.haskell.org/debian/
# ghc-9.0.1 is too new
# see https://github.com/input-output-hk/cardano-node/issues/2351 and https://forum.cardano.org/t/fresh-build-of-1-14-1-causes-could-not-resolve-dependencies-exception/35023
apt-get -y install cabal-install-3.4 ghc-8.10.4 || exit -1
/opt/cabal/bin/cabal --version

mkdir -p ~/src
cd ~/src
git clone https://github.com/input-output-hk/cardano-node.git || exit -1
cd cardano-node
git fetch --all --recurse-submodules --tags

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

if [[ "$branch" == "test" ]]
then
  tag="1.35.2"
else
  tag=`get_latest_release "input-output-hk/cardano-node"`
fi

git checkout tags/$tag -b stable-$tag
export PATH=$PATH:/opt/cabal/bin/:/opt/ghc/bin/
cabal update || exit -1
cabal configure --with-compiler=ghc-8.10.4 || exit -1
echo "package cardano-crypto-praos" >>  cabal.project.local
echo "  flags: -external-libsodium-vrf" >>  cabal.project.local
cabal build all || exit -1
mkdir -p ~/.local/bin
cabal install --installdir ~/.local/bin cardano-cli cardano-node || exit -1

mkdir -p /root/cardano-bin
cp -p dist-newstyle/build/x86_64-linux/ghc-8.10.4/cardano-node-$tag/x/cardano-node/build/cardano-node/cardano-node /root/cardano-bin
cp -p dist-newstyle/build/x86_64-linux/ghc-8.10.4/cardano-cli-$tag/x/cardano-cli/build/cardano-cli/cardano-cli /root/cardano-bin
cd /root
mkdir /root/sources
tar czf /root/sources/cardano-bin.tar.gz cardano-bin

cd ~/lbs-cardano/cardano-bin
sed -i  "s/1.0.0/$tag/g" debian/changelog
sed -i  "s/1.0.0/$tag/g" cardano-bin.dsc
