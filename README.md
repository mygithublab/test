# Template for deploy nagios docker of Ubuntu

Testing or template

Standalone mode:

`docker run -itd --name test -p 5001:22 -p 5000:80  -v /volume2:/share --restart=always test`

External custom mode:

`docker run -itd --name test -p 5001:22 -p 5000:80 \
 -v $WORKSPACE/etc:/usr/local/nagios/etc \
 -v /volume/nagios/var:/usr/local/nagios/var \
 -v /volume/nagiosgraph/var:/usr/local/nagiosgraph/var \
 -v /volume2:/share \
 --restart=always \
 test
`

1. After Nagios completed initialized then, copy nagios and nagiosgraph var folder to local host where is running nagios container.

2. Nagios/etc foler mount to github /etc folder, add host into object file, push to trigger a nagios restart.

3. Nagios/var folder mount to host folder. Log data with volume container as well.

4. Remove nagios container, the previous data still exist.

5. Fixed problem with not working multiple selection for nagiosgraph datasets and periods. 

6. Migration Nagios and Nagiosgraph var folder to backup location.
