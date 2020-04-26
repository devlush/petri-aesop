#!/bin/sh

echo Building local/trinity_ipxe:build ...

docker build \
    --tag local/trinity_ipxe:build . \
    --file Dockerfile.build-ipxe

mkdir -p ./deps
rm -rf ./deps/ipxe

docker container create --name extract_ipxe local/trinity_ipxe:build
docker container cp extract_ipxe:/hardhat/build_artifacts ./deps/ipxe
docker container rm -f extract_ipxe

