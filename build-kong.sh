#!/usr/bin/env bash
set -e
source /env.sh  # created by build-openresty.sh

# Build Kong from source.
git clone https://github.com/kong/kong
cd kong

# use master version at time of writing for reproducibility
git checkout fd8a2233e179c7ec79e2af155c24616c9a8d6e71

# Add patches to mitigate race condition in perf tests
git apply /0001-tests-perf-docker-driver-wait-until-upstream-is-onli.patch
git apply /0002-docker.lua-Hack-to-stop-issuing-Git-commands-workaro.patch
git apply /0003-docker.lua-Hack-to-wait-10-seconds-for-Kong-to-start.patch

make install
make dev

