#!/usr/bin/env bash
source /env.sh
cd kong
bin/busted spec/04-perf/01-rps/01-simple_spec.lua
