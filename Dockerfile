FROM ubuntu:18.04
MAINTAINER Rion Dooley <dooley@tacc.utexas.edu>

RUN apt-get update && \
        apt-get install -y wget gnupg && \
        wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - && \
        echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list && \
        apt-key update && \
        apt-get update && \
        apt-get install -y mongodb-database-tools python-pip && \
        pip install awscli && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* && \
        rm -rf /tmp/* && \
        mkdir /backup

ENV CRON_TIME="0 0 * * *"
ENV S3_PATH=mongodb
ENV AWS_DEFAULT_REGION=us-east-1

ADD docker_entrypoint.sh /docker_entrypoint.sh
ADD backup.sh /backup.sh
ADD restore.sh /restore.sh
ADD sync.sh /sync.sh

VOLUME ["/backup"]

ENTRYPOINT ["/docker_entrypoint.sh"]

CMD ["sync"]
