#!/usr/bin/env bash
set -e

# Build Kong version of OpenResty from source.

git clone https://github.com/kong/kong-build-tools

# use master version at time of writing for reproducibility
cd kong-build-tools
git checkout aa83794708cf5b410ed2c8e04b370d339178d63f

cd openresty-build-tools
./kong-ngx-build -p build \
    --openresty 1.19.9.1 \
    --openssl 1.1.1m \
    --luarocks 3.8.0 \
    --pcre 8.45

#
# Setup environment to see dependencies for Kong build
#

cd build
cat > /env.sh <<EOF
export PATH=$(pwd)/openresty/bin:$(pwd)/openresty/nginx/sbin:$(pwd)/luarocks/bin:\$PATH
export OPENSSL_DIR=$(pwd)/openssl

eval \$(luarocks path)
EOF


