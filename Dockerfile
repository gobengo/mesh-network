FROM debian:jessie-slim

RUN apt-get update

RUN apt-get install -yq curl

# doctl - CLI for DigitalOcean

ARG DOCTL_VERSION=1.7.1
ARG DOCTL_FILE=doctl-$DOCTL_VERSION-linux-amd64.tar.gz
RUN curl -OL https://github.com/digitalocean/doctl/releases/download/v$DOCTL_VERSION/$DOCTL_FILE
RUN mkdir /tmp/doctl/
RUN tar -xf "$DOCTL_FILE" -C /tmp/
RUN mv /tmp/doctl /usr/local/bin/doctl

# This project

## deps
RUN apt-get install -yq \
    iproute2 \
    net-tools \
    openssh-client \
    rsync \
    ;

ARG PROJECT_DIR=/opt/bengomesh
RUN mkdir -p $PROJECT_DIR
WORKDIR $PROJECT_DIR
COPY . $PROJECT_DIR
ENTRYPOINT ["./bin/docker-entrypoint"]
