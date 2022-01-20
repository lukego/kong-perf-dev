FROM ubuntu

RUN DEBIAN_FRONTEND=noninteractive apt-get update

# List copied from DEVELOPER.md commit 34fc11ccf8461df09bb2e194c0393c0d004b454c
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    automake \
    build-essential \
    curl \
    docker \
    docker-compose \
    git \
    libpcre3 \
    libyaml-dev \
    m4 \
    openssl \
    perl \
    procps \
    unzip \
    zlib1g-dev

# Build openresty from source and create /env.sh
ADD build-openresty.sh /build-openresty.sh
RUN /build-openresty.sh

# Build kong from source
ADD build-kong.sh /build-kong.sh
ADD 0001-tests-perf-docker-driver-wait-until-upstream-is-onli.patch /0001-tests-perf-docker-driver-wait-until-upstream-is-onli.patch
RUN /build-kong.sh

ADD execute-perf-test.sh /execute-perf-test.sh
