#! /bin/bash

set -e

VERSION="1.0.0"

source ./pika-build-config.sh

echo "$PIKA_BUILD_ARCH" > pika-build-arch

# Clone Upstream
mkdir -p pikman-update-manager
cp -rvf ./* ./pikman-update-manager/ || true
cd ./pikman-update-manager/

# Get build deps
apt-get build-dep ./ -y
apt-get install curl -y
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | CARGO_HOME=/root/.cargo sh -s -- -y

# Build package
LOGNAME=root dh_make --createorig -y -l -p pikman-update-manager_"$VERSION" || echo "dh-make: Ignoring Last Error"
dpkg-buildpackage --no-sign

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
