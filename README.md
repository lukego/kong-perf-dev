# Intro

This is a simple proof-of-concept packaging of the [Kong performance
test framework](https://docs.konghq.com/gateway/2.7.x/plan-and-deploy/performance-testing-framework/)
in Docker.

It does two things:

1. Build a docker container with a working version of the performance testing framework.
2. Run the performance tests in that container with appropriate docker arguments.

`./test.sh` runs both of these steps and should be all you need to run (see expected output below.)

The scripts take some basic precautious for reproducibility:

- Checkout the same versions (git commit) of `kong` and
  `kong-build-tools` that were used for testing, i.e. the master
  branch version of both at the time of writing.

- Apply a patch to resolve a race condition that was present in the
  performance test suite at the time of testing. The patch file is
  included in this repo (and should be upstreamed separately.)

Let me know if you need help!
-- Luke Gorrie <luke.gorrie@konghq.com>

# Expected output

Below is a transcript of the expected output.

Note that First run will be much noisier while Docker builds the container.

```
$ time ./test.sh 
Sending build context to Docker daemon  77.31kB
Step 1/9 : FROM ubuntu
 ---> d13c942271d6
Step 2/9 : RUN DEBIAN_FRONTEND=noninteractive apt-get update
 ---> Using cache
 ---> 88d9f12e7f61
Step 3/9 : RUN DEBIAN_FRONTEND=noninteractive apt-get install -y     automake     build-essential     curl     docker     docker-compose     git     libpcre3     libyaml-dev     m4     openssl     perl     procps     unzip     zlib1g-dev
 ---> Using cache
 ---> ce084c390a6f
Step 4/9 : ADD build-openresty.sh /build-openresty.sh
 ---> Using cache
 ---> a5bd048f4345
Step 5/9 : RUN /build-openresty.sh
 ---> Using cache
 ---> ebaebc0c53ca
Step 6/9 : ADD build-kong.sh /build-kong.sh
 ---> Using cache
 ---> 97636eac353b
Step 7/9 : ADD 0001-tests-perf-docker-driver-wait-until-upstream-is-onli.patch /0001-tests-perf-docker-driver-wait-until-upstream-is-onli.patch
 ---> Using cache
 ---> 94335715e9ae
Step 8/9 : RUN /build-kong.sh
 ---> Using cache
 ---> 7b86bdac582d
Step 9/9 : ADD execute-perf-test.sh /execute-perf-test.sh
 ---> Using cache
 ---> 0e3cfda99312
Successfully built 0e3cfda99312
Successfully tagged kong-perf-dev:latest
2022/01/20 09:57:55 [warn] [Penlight 1.12.0] the contents of module 'pl.text' has moved into 'pl.stringx' (deprecated after 1.11.0, scheduled for removal in 2.0.0)
09:57:50.948   [info] [docker] psql container ID is 7d4227fc6a4aeff5c709cdad971346e1f5c4d9f6ebaa7c79584d3f3087528981
09:57:52.257   [info] [docker] psql is started to listen at port 49219
09:57:55.458  [debug] [docker] => Sending build context to Docker daemon  2.048kB
09:57:55.483  [debug] [docker] => Step 1/6 : FROM nginx:alpine
09:57:55.483  [debug] [docker] =>  ---> cc44224bfe20
09:57:55.483  [debug] [docker] => Step 2/6 : RUN apk update && apk add wrk
09:57:55.483  [debug] [docker] =>  ---> Using cache
09:57:55.483  [debug] [docker] =>  ---> 9be7b14e4f75
09:57:55.483  [debug] [docker] => Step 3/6 : RUN echo -e '        server {          listen 18088 reuseport;          access_log off;          location =/health {             return 200;           }                 location = /test {\n        return 200;\n      }\n               }' > /etc/nginx/conf.d/perf-test.conf
09:57:55.483  [debug] [docker] =>  ---> Using cache
09:57:55.483  [debug] [docker] =>  ---> 9934fad6d59b
09:57:55.483  [debug] [docker] => Step 4/6 : ENTRYPOINT ["/docker-entrypoint.sh"]
09:57:55.483  [debug] [docker] =>  ---> Using cache
09:57:55.483  [debug] [docker] =>  ---> 386111923715
09:57:55.483  [debug] [docker] => Step 5/6 : STOPSIGNAL SIGQUIT
09:57:55.483  [debug] [docker] =>  ---> Using cache
09:57:55.483  [debug] [docker] =>  ---> 7800f9b0ec9b
09:57:55.483  [debug] [docker] => Step 6/6 : CMD ["nginx", "-g", "daemon off;"]
09:57:55.484  [debug] [docker] =>  ---> Using cache
09:57:55.484  [debug] [docker] =>  ---> 4b64362cd64d
09:57:55.484  [debug] [docker] => Successfully built 4b64362cd64d
09:57:55.499  [debug] [docker] => Successfully tagged perf-test-upstream:latest
09:57:55.896   [info] [docker] worker container ID is dc98a57743217132eadd86b3acbefda020666e3d7f1dfa4bd66900a7c1b7ef7b
09:57:56.198   [info] [docker] worker is started
09:57:56.198   [info] [docker] waiting for worker to be reachable on port 18088
09:57:56.298   [info] [docker] worker is reachable on port 18088
### Result for upstream directly (run 1):
Running 30s test @ http://172.17.0.3:18088/test
  5 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   824.44us    1.81ms  30.26ms   89.29%
    Req/Sec   190.71k    28.95k  260.25k    64.06%
  28487646 requests in 30.10s, 4.27GB read
Requests/sec: 946515.75
Transfer/sec:    145.33MB
### Result for upstream directly (run 2):
Running 30s test @ http://172.17.0.3:18088/test
  5 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   747.97us    1.66ms  29.03ms   89.58%
    Req/Sec   178.20k    24.71k  237.48k    66.22%
  26617923 requests in 30.08s, 3.99GB read
Requests/sec: 884868.29
Transfer/sec:    135.86MB
### Result for upstream directly (run 3):
Running 30s test @ http://172.17.0.3:18088/test
  5 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   767.84us    1.71ms  28.95ms   89.70%
    Req/Sec   168.48k    23.09k  218.98k    66.13%
  25199664 requests in 30.10s, 3.78GB read
Requests/sec: 837317.01
Transfer/sec:    128.56MB
### Combined result for upstream directly:
RPS     Avg: 889567.02
Latency Avg: nanms    Max: nanms
  
+09:59:27.232  [debug] [docker] => dc98a57743217132eadd86b3acbefda020666e3d7f1dfa4bd66900a7c1b7ef7b
09:59:27.591  [debug] [docker] => 7d4227fc6a4aeff5c709cdad971346e1f5c4d9f6ebaa7c79584d3f3087528981

1 success / 0 failures / 0 errors / 0 pending : 97.061671 seconds

real	1m37.862s
user	0m0.037s
sys	0m0.014s

```
