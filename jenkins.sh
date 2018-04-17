#/bin/bash

docker build -t external .
docker rm -f external
#docker run -itd --name test -p 5001:22 -p 5000:80  -v /volume2:/share --restart=always test

docker run -itd --name external -p 10001:22 -p 10000:80 \
 -v $WORKSPACE/etc:/usr/local/nagios/etc \
 -v /volume3/nagios/var:/usr/local/nagios/var \
 -v /volume3/nagiosgraph/var:/usr/local/nagiosgraph/var \
 -v /volume2:/share \
 --restart=always external
