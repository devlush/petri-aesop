#!/bin/sh

echo Building local/razor_microkernel:build ...

docker build \
    --tag local/razor_microkernel:build . \
    --file Dockerfile.build-mk

mkdir -p ./deps
rm -rf ./deps/mk

