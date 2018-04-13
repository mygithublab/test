#!/bin/bash

/etc/init.d/ssh restart
/etc/init.d/cron restart
/etc/init.d/ntp force-reload 
/etc/init.d/ntp restart
/etc/init.d/nagios restart
/etc/init.d/apache2 restart
/bin/bash
