# Template for deploy nagios core 4.4.2 docker of Ubuntu

Build Status: [![Build Status](https://travis-ci.org/mygithublab/test.svg?branch=master)](https://travis-ci.org/mygithublab/test)

Testing or template

Standalone mode:

`docker run -itd --name test -p 10086:80 -p 10087:22  -v /test:/share --restart=always github-test-ubuntu-nagios-image`

External mode:

`docker run -itd --name test -p 10087:22 -p 10086:80 \
 -v $WORKSPACE/etc:/usr/local/nagios/etc \
 -v /github/test/nagios/var:/usr/local/nagios/var \
 -v /github/test/nagiosgraph/var:/usr/local/nagiosgraph/var \
 -v /test:/share \
 --restart=always \
 github-test-ubuntu-nagios-image
`

1. After Nagios completed initialized, then, copy nagios and nagiosgraph var folder to local host where is running nagios container.

2. Nagios/etc foler mount to github /etc folder, add host into object file, push to trigger a nagios restart.

3. Nagios/var folder mount to host folder. Log data with volume container as well.

4. Remove nagios container, the previous data still exist.

5. Fixed problem with not working multiple selection for nagiosgraph datasets and periods. 

6. Migration Nagios and Nagiosgraph var folder to backup location.


## Fuction

1. Check Memory.

2. Check TCP traffic.


P.S
In jenkins configration, add following script into excute shell.

`#!/bin/bash`

`$WORKSPACE/jenkins.sh`

Thanks.


Update later...
