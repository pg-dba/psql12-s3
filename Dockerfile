FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y lsb-release gnupg2 apt-utils wget
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN mkdir /var/lib/postgresql
RUN groupadd -g 999 postgres
RUN useradd -u 999 -g 999 postgres -d /var/lib/postgresql -s /bin/bash
RUN chown 999:999 /var/lib/postgresql
RUN apt-get -y install postgresql-client-12 postgresql-contrib-12 perl barman-cli awscli gosu nano mutt iputils-ping dnsutils telnet
RUN apt-get clean all
RUN wget --quiet https://dl.min.io/client/mc/release/linux-amd64/mc
RUN chmod 700 mc
RUN mv mc /usr/bin/

RUN mkdir -p /var/lib/postgresql/data

VOLUME /var/lib/postgresql/data

COPY s3-entrypoint.sh /s3-entrypoint.sh
RUN chmod 700 /s3-entrypoint.sh

COPY help-restore.sh /root/help-restore.sh
RUN chmod 700 /root/help-restore.sh

COPY list-backups.sh /root/list-backups.sh
RUN chmod 700 /root/list-backups.sh

COPY restore.sh /root/restore.sh
RUN chmod 700 /root/restore.sh

WORKDIR /root

ENTRYPOINT ["/s3-entrypoint.sh"]

CMD ["/bin/bash"]
