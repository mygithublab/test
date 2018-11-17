#!/bin/bash

docker build -t github-test-ubuntu-nagios-image .
docker rm -f github-test-ubuntu-nagios-container
#docker run -itd --name github-test-ubuntu-nagios-container -p 10001:22 -p 10000:80  -v /volume2:/share --restart=always github-test-ubuntu-nagios-image

docker run -itd --name github-test-ubuntu-nagios-container -p 10086:80 -p 10087:22 \
 -v $WORKSPACE/etc:/usr/local/nagios/etc \
 -v /github/test/nagios/var:/usr/local/nagios/var \
 -v /github/test/nagiosgraph/var:/usr/local/nagiosgraph/var \
 -v /test:/share \
 --restart=always github-test-ubuntu-nagios-image
