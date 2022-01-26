#!/usr/bin/env bash
source /env.sh
cd kong
export PERF_TEST_VERSIONS=git:HEAD
bin/busted spec/04-perf/01-rps/01-simple_spec.lua
