#!/usr/bin/env bash

# Build kong-perf-dev container using the steps outlined in DEVELOPER.md.
docker build -t kong-perf-dev .

# Run tests with access to the host docker daemon for simple docker-in-docker.
docker run --network host -v /run/docker.sock:/run/docker.sock \
       kong-perf-dev /execute-perf-test.sh

