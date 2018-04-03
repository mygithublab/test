FROM ubuntu
RUN apt-get update && apt-get install -y \
    openssh-server \
    git \
    vim \
    cron \
    ntp \
    ntpdate \
    tzdata \
 && apt-get clean

#Install Nagios
ADD nagios-4.3.4.tar.gz /tmp
ADD nagios-plugins-2.2.1.tar.gz /tmp
RUN apt-get update && apt-get install -y \
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
#plugin
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
 && apt-get clean \
# && cd /tmp \
# && wget --no-check-certificate -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.3.4.tar.gz \
# && tar zxvf nagioscore.tar.gz \
 && cd /tmp/nagios-4.3.4/ \
 && ./configure --with-httpd-conf=/etc/apache2/sites-enabled \
 && make all \
 && useradd nagios \
 && usermod -a -G nagios www-data \
 && make install \
 && make install-init \
 && update-rc.d nagios defaults \
 && make install-commandmode \
 && make install-config \
 && make install-webconf \
 && a2enmod rewrite \
 && a2enmod cgi \
 && htpasswd -bcs /usr/local/nagios/etc/htpasswd.users nagiosadmin nagios \
 && /etc/init.d/apache2 restart \
 && /etc/init.d/nagios restart \
# && cd /tmp \
# && wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz \
# && tar zxvf nagios-plugins.tar.gz \
 && cd /tmp/nagios-plugins-2.2.1/ \
 && ./tools/setup \
 && ./configure \
 && make \
 && make install \
 && /etc/init.d/apache2 restart \
 && /etc/init.d/nagios restart \

ADD run.sh /run.sh
ADD script.sh /script.sh
ADD authorized_keys /root/.ssh/authorized_keys
RUN mkdir /share \
 && chmod 755 /run.sh \
 && chmod 755 /script.sh \
 && chmod 700 /root/.ssh \
 && chmod 600 /root/.ssh/authorized_keys
RUN sed -i '$a * * * * * root bash /script.sh' /etc/crontab \
 && sed -i 's/Etc\/UTC/Asia\/Shanghai/g' /etc/timezone \ 
 && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
 && sed -i '$a server 0.ubuntu.pool.ntp.org' /etc/ntp.conf \
 && sed -i '$a server 1.ubuntu.pool.ntp.org' /etc/ntp.conf \
 && sed -i '$a server 2.ubuntu.pool.ntp.org' /etc/ntp.conf \
 && sed -i '$a server 3.ubuntu.pool.ntp.org' /etc/ntp.conf

EXPOSE 80 22

VOLUME "/share"

CMD ["/run.sh"]
