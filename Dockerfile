FROM ubuntu
RUN apt-get update && apt-get install -y \
    openssh-server \
    git \
    vim \
    cron \
 && apt-get clean

ADD run.sh /run.sh
ADD script.sh /script.sh
RUN chmod 755 /run.sh && chmod 755 /script.sh && mkdir -p /root/.ssh && mkdir /share
COPY run.sh /share
COPY authorized_keys /root/.ssh
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys
RUN sed -i '$a * * * * * root bash /script.sh' /etc/crontab

EXPOSE 80 22

VOLUME "/share"

CMD ["/run.sh"]
