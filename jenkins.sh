#/bin/bash

docker build -t test .
docker rm -f test
#docker run -itd --name test -p 5001:22 -p 5000:80  -v /volume2:/share --restart=always test

docker run -itd --name test -p 5001:22 -p 5000:80 \
 -v $WORKSPACE/resource/nagios/etc:/usr/local/nagios/etc \
 -v /volume/nagios/var:/usr/local/nagios/var \
 -v /volume/nagiosgraph/var:/usr/local/nagiosgraph/var \
 -v /volume2:/share \
 --restart=always \
 test
