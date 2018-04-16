# test & deploy nagios docker

Testing

Standalone mode:

`docker run -itd --name test -p 5001:22 -p 5000:80 -v /volume:/share test`

External custom mode: 

`docker run -itd --name test -p 5001:22 -p 5000:80 \
 -v $WORKSPACE/resource/nagios/etc:/usr/local/nagios/etc \
 -v /volume/nagios/var:/usr/local/nagios/var \
 -v /volume2:/share \
 test`

1. copy nagios and nagiosgraph folder to local host which running nagios container.

2. nagios/etc foler mount to github /etc folder, add host into object file, push to trigger a nagios restart.

3. nagios/var folder mount to host folder.  Log data also use volume container to replace.

4. copy nagios and nagiosgraph folder to local host.

5. Remove nagios container, the previous data still exist.
