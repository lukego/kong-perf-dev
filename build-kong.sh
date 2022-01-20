#!/usr/bin/env bash
set -e
source /env.sh  # created by build-openresty.sh

# Build Kong from source.
git clone https://github.com/kong/kong
cd kong

# use master version at time of writing for reproducibility
git checkout fd8a2233e179c7ec79e2af155c24616c9a8d6e71

# Add patch to avoid race condition in perf tests
git apply /0001-tests-perf-docker-driver-wait-until-upstream-is-onli.patch

make install
make dev

