FROM ubuntu
RUN apt-get update && apt-get install -y \
    openssh-server \
    git \
    vim \
    cron \
    ntp \
#   ntpdate \
    tzdata \
 && apt-get clean

ADD run.sh /run.sh
ADD script.sh /script.sh
COPY run.sh /share
COPY authorized_keys /root/.ssh
RUN chmod 755 /run.sh && chmod 755 /script.sh && mkdir -p /root/.ssh && mkdir /share \
 && chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys
RUN sed -i '$a * * * * * root bash /script.sh' /etc/crontab
RUN sed -i 's/Etc\/UTC/Asia\/Shanghai/g' /etc/timezone \
 && sed -i '$a server 0.ubuntu.pool.ntp.org' /etc/ntp.conf \
 && sed -i '$a server 1.ubuntu.pool.ntp.org' /etc/ntp.conf \
 && sed -i '$a server 2.ubuntu.pool.ntp.org' /etc/ntp.conf \
 && sed -i '$a server 3.ubuntu.pool.ntp.org' /etc/ntp.conf

EXPOSE 80 22

VOLUME "/share"

CMD ["/run.sh"]
