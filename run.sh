#!/bin/bash

/etc/init.d/ssh restart
/etc/init.d/cron restart
#/etc/init.d/ntp force-reload 
##/etc/init.d/ntp restart
ntpdate cn.pool.ntp.org
/bin/bash
