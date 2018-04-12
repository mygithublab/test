# test

Testing for docker

`docker run -itd --name test -p 5001:22 -p 5000:80 -v /volume:/share test`

`docker run -itd --name test -p 5001:22 -p 5000:80 \
 -v $WORKSPACE/etc:/usr/local/nagios/etc \
 -v /volume/nagios/var:/usr/local/nagios/var \
 -v /volume2:/share \
 test`

1. nagios/etc foler mount to github /etc folder, add host into object file, push to trigger a nagios restart.

2. nagios/var folder mount to host folder.  Log data also use volume container to replace.

3. Remove nagios container, the previous data still exist. 

