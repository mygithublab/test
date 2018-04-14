#!/bin/bash

docker build -t test .
docker rm -f test
#docker run -itd --name test -p 5001:22 -p 5000:80 -v /volume:/share test
docker run -itd --name test -p 5001:22 -p 5000:80 -v /volume2:/share test
# -v $WORKSPACE/etc:/usr/local/nagios/etc \
# -v /volume/nagios/var:/usr/local/nagios/var \
# -v /volume2:/share \
# test
