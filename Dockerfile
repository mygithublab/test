#This dockerfile base on Ubuntu image
#Author: mygithublab@126.com
#Nagios core 4.4.2 with Nagiosgraph

FROM ubuntu:16.04

#Maintainer information
MAINTAINER Mygithub (mygithublab@126.com)

#Setup environment
ENV NAGIOSADMIN_USER nagiosadmin
ENV NAGIOSADMIN_PASS nagios

#Copy local Nagios installation to container
#ADD nagios-4.3.4.tar.gz /tmp
#ADD nagios-plugins-2.2.1.tar.gz /tmp

#Install tools
RUN apt-get update && apt-get install -y \
    openssh-server \
    git \
    vim \
    cron \
    ntp \
    ntpdate \
    tzdata \

#Prerequisties software for Nagios Core
    autoconf \
    gcc \
    libc6 \
    make \
    wget \
    unzip \
    apache2 \
    php \
    libapache2-mod-php7.0 \
    libgd2-xpm-dev \

#Prerequisties software for Nagios plugin
    autoconf \
    gcc \
    libc6 \
    libmcrypt-dev \
    make \
    libssl-dev \
    wget \
    bc \
    gawk \
    dc \
    build-essential \
    snmp \
    libnet-snmp-perl \
    gettext \

#Prerequisties softeare for NagiosGraph
    libcgi-pm-perl \
    librrds-perl \
    libgd-gd2-perl \
    libnagios-object-perl \

#Prerequisies software for ping function
    inetutils-ping \
    net-tools \
 && apt-get clean 

#Download and nagios core and nagios plug-in to /tmp folder
RUN cd /tmp \
 && wget --no-check-certificate -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.1.tar.gz \
 && tar zxvf nagioscore.tar.gz \
 && cd /tmp/nagioscore-nagios-4.4.1/ \
 && ./configure --with-httpd-conf=/etc/apache2/sites-enabled \
 && make all \
# && useradd nagios \ ;4.3.4 installation
 && make install-groups-users \
 && usermod -a -G nagios www-data \
 && make install \
# && make install-init \ ;4.3.4 installation
# && update-rc.d nagios defaults \ ;4.3.4 installation
 && make install-daemoninit \
 && make install-commandmode \
 && make install-config \
 && make install-webconf \
 && a2enmod rewrite \
 && a2enmod cgi \
 && htpasswd -bcs /usr/local/nagios/etc/htpasswd.users "${NAGIOSADMIN_USER}" "${NAGIOSADMIN_PASS}" \
 && cd /tmp \
 && wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz \
 && tar zxvf nagios-plugins.tar.gz \
 && cd /tmp/nagios-plugins-release-2.2.1/ \
 && ./tools/setup \
 && ./configure \
 && make \
 && make install \
#check nagios installation status 
 && /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

#Downloading nagiosGraph to /tmp folder
RUN cd /tmp && wget --no-check-certificate -O nagiosgraph.tar.gz https://nchc.dl.sourceforge.net/project/nagiosgraph/nagiosgraph/1.5.2/nagiosgraph-1.5.2.tar.gz \
 && tar zxvf nagiosgraph.tar.gz && cd /tmp/nagiosgraph-1.5.2 \
 && ./install.pl --install                                              \
         --prefix                   /usr/local/nagiosgraph              \
         --etc-dir                  /usr/local/nagiosgraph/etc          \
         --var-dir                  /usr/local/nagiosgraph/var          \
         --log-dir                  /usr/local/nagiosgraph/var/log      \
         --doc-dir                  /usr/local/nagiosgraph/doc          \
         --nagios-cgi-url           /nagiosgraph/cgi-bin                \
         --nagios-perfdata-file     /usr/local/nagios/var/perfdata.log  \
         --nagios-user              nagios                              \
         --www-user                 www-data                            \ 

#Graphs in Nagios Mouseovers for nagiosGraph
 && cp share/nagiosgraph.ssi /usr/local/nagios/share/ssi/common-header.ssi \
# line 172 4.3.4 installation
 && sed -i '181a \\taction_url\t\t\t\/nagiosgraph\/cgi-bin\/show.cgi?host=$HOSTNAME$&service=$SERVICEDESC$'\'' onMouseOver='\''showGraphPopup(this)'\'' onMouseOut='\''hideGraphPopup()'\'' rel='\''\/nagiosgraph\/cgi-bin\/showgraph.cgi?host=$HOSTNAME$&service=$SERVICEDESC$&period=day&rrdopts=-w+450+-j' /usr/local/nagios/etc/objects/templates.cfg \
# line 185 4.3.4 installation
 && sed -i '197a \\taction_url\t\t\t\/nagiosgraph\/cgi-bin\/show.cgi?host=$HOSTNAME$&service=$SERVICEDESC$'\'' onMouseOver='\''showGraphPopup(this)'\'' onMouseOut='\''hideGraphPopup()'\'' rel='\''\/nagiosgraph\/cgi-bin\/showgraph.cgi?host=$HOSTNAME$&service=$SERVICEDESC$&period=day&rrdopts=-w+450+-j' /usr/local/nagios/etc/objects/templates.cfg \

#check nagios installation status
 && /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg \

#Configuring Data Processing for nagiosGraph
 && sed -i 's/process_performance_data=0/process_performance_data=1/g' /usr/local/nagios/etc/nagios.cfg \
 && sed -i '$a service_perfdata_file=\/usr\/local\/nagios\/var\/perfdata.log' /usr/local/nagios/etc/nagios.cfg \
 && sed -i '$a service_perfdata_file_template=\$LASTSERVICECHECK\$\|\|\$HOSTNAME\$\|\|\$SERVICEDESC\$\|\|$SERVICEOUTPUT\$\|\|\$SERVICEPERFDATA\$' /usr/local/nagios/etc/nagios.cfg \
 && sed -i '$a service_perfdata_file_mode=a' /usr/local/nagios/etc/nagios.cfg \
 && sed -i '$a service_perfdata_file_processing_interval=10' /usr/local/nagios/etc/nagios.cfg \
 && sed -i '$a service_perfdata_file_processing_command=process-service-perfdata-for-nagiosgraph' /usr/local/nagios/etc/nagios.cfg \

#check nagios installation status
 && /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg \

# && cat <<EOF>>/usr/local/nagios/etc/objects/commands.cfg
#define command {
#        command_name process-service-perfdata-for-nagiosgraph
#        command_line /usr/local/nagiosgraph/bin/insert.pl
#        }
# EOF \

#define the process-service-perfdata command for nagiosGraph
 && sed -i '$a define command \{' /usr/local/nagios/etc/objects/commands.cfg \
 && sed -i '$a \\t command_name process-service-perfdata-for-nagiosgraph' /usr/local/nagios/etc/objects/commands.cfg \
 && sed -i '$a \\t command_line /usr/local/nagiosgraph/bin/insert.pl' /usr/local/nagios/etc/objects/commands.cfg \
 && sed -i '$a \\t \}' /usr/local/nagios/etc/objects/commands.cfg \

#check nagios installation status
 && /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg \

#Configuring Graphing and Display for nagiosGraph
 && sed -i '$a Include /usr/local/nagiosgraph/etc/nagiosgraph-apache.conf' /etc/apache2/apache2.conf \
 && sed -i '2,7 s/^#//' /usr/local/nagiosgraph/etc/nagiosgraph-apache.conf \
 && sed -i '12 s/^#//' /usr/local/nagiosgraph/etc/nagiosgraph-apache.conf \
 && sed -i '156 s/denied/granted/' /etc/apache2/apache2.conf \

 && sed -i '$a default_geometry = 1000x200' /usr/local/nagiosgraph/etc/nagiosgraph.conf \
 && sed -i 's/action_url_target=_blank/action_url_target=_self/g' /usr/local/nagios/etc/cgi.cfg \
 && sed -i 's/notes_url_target=_blank/notes_url_target=_self/g' /usr/local/nagios/etc/cgi.cfg \
 && sed -i 's/result_limit=100/result_limit=0/g' /usr/local/nagios/etc/cgi.cfg \

#check nagios installation status
 && /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg \

#Fixes problem with not working multiple selection for nagiosgraph datasets and periods
 && sed -i '2467 s/$cgi->td($cgi->popup_menu(-name => '\''period'\'', -values => \[@PERIOD_KEYS\], -labels => \\%period_labels, -size => PERIODLISTROWS, -multiple => 1)), "\\n",/$cgi->td($cgi->popup_menu(-name => '\''period'\'', -values => \[@PERIOD_KEYS\], -labels => \\%period_labels, -size => PERIODLISTROWS, -multiple)), "\\n",/' /usr/local/nagiosgraph/etc/ngshared.pm \
 && sed -i '2460 s/$cgi->td($cgi->popup_menu(-name => '\''db'\'', -values => \[\], -size => DBLISTROWS, -multiple => 1)), "\\n",/$cgi->td($cgi->popup_menu(-name => '\''db'\'', -values => \[\], -size => DBLISTROWS, -multiple)), "\\n",/' /usr/local/nagiosgraph/etc/ngshared.pm \

#Clean /tmp folder
&& rm -rf /tmp/*

ADD run.sh /run.sh
ADD script.sh /script.sh
ADD authorized_keys /root/.ssh/authorized_keys
RUN mkdir /share \
 && chmod 755 /run.sh \
 && chmod 755 /script.sh \
 && chmod 700 /root/.ssh \
 && chmod 600 /root/.ssh/authorized_keys \

#Copy ngios and graph to /bk folder 
 && mkdir -p /bk/nagios \
 && mkdir -p /bk/nagiosgraph \
 && cp -R -p /usr/local/nagios/etc /bk/nagios \
 && cp -R -p /usr/local/nagios/var /bk/nagios \
 && cp -R -p /usr/local/nagiosgraph/var /bk/nagiosgraph \
 && cp -R -p /usr/local/nagios/libexec /bk/nagios \
 && cp -R -p /usr/local/nagiosgraph/etc /bk/nagiosgraph \

#Define schedule task and ntp timezone
 && sed -i '$a * * * * * root bash /script.sh' /etc/crontab \
 && sed -i 's/Etc\/UTC/Asia\/Shanghai/g' /etc/timezone \ 
 && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
 && sed -i '$a server 0.ubuntu.pool.ntp.org' /etc/ntp.conf \
 && sed -i '$a server 1.ubuntu.pool.ntp.org' /etc/ntp.conf \
 && sed -i '$a server 2.ubuntu.pool.ntp.org' /etc/ntp.conf \
 && sed -i '$a server 3.ubuntu.pool.ntp.org' /etc/ntp.conf 

EXPOSE 80 22

VOLUME "/share" "/usr/local/nagios/etc" "/usr/local/nagios/var" "/usr/local/nagios/libexec" "/usr/local/nagiosgraph/var" "/usr/local/nagiosgraph/etc"

CMD ["/run.sh"]
