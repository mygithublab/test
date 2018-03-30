FROM ubuntu
RUN apt-get update && apt-get install -y \
    openssh-server \
    git \
    vim 

ADD run.sh /run.sh
RUN chmod 755 /run.sh && mkdir -p /root/.ssh && mkdir /share
COPY authorized_keys /root/.ssh
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys

EXPOSE 80 22

VOLUME "/share"

CMD ["/run.sh"]
