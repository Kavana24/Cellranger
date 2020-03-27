FROM ubuntu:16.04

MAINTAINER nandini

RUN apt update -y

ENV GCSFUSE_REPO gcsfuse-jessie

RUN apt-get update && apt-get install --yes --no-install-recommends \
    ca-certificates \
    curl \
  && echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" \
    | tee /etc/apt/sources.list.d/gcsfuse.list \
  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && apt-get update \
  && apt-get install --yes gcsfuse \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN \
  apt update -y && \
  apt install -y \
  wget && \
 # rust 1.28.0 \
 # clang 6.0 \
 # go 1.11 \
 # node v8.11.4 && \
  apt clean all

#RUN apt install python 2.7

#install gsutil
RUN apt-get install --yes apt-transport-https ca-certificates

RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk main " | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y google-cloud-sdk

RUN mkdir mounttest

#install java and jenkins-cli.jar
#downloading jenkins-cli.jar from jenkins-master1 
RUN apt-get update -y && apt-get install default-jre -y && \
    curl --insecure -OL http://10.60.2.24:8080/jnlpJars/jenkins-cli.jar --output /jenkins-cli.jar

#Install mysql-core-client-5.7
RUN apt-get update && \
    apt-get install -y mysql-client

#Install dos2unix and csvtool
RUN apt-get update \
    && apt-get install -y dos2unix
RUN apt-get update \
    && apt-get install -y csvtool

#Install git
RUN apt-get update \
    && apt-get install -y git


ENV CELLRANGER_VER 3.1.0

# Pre-downloaded file
COPY cellranger-$CELLRANGER_VER.tar.gz /opt/cellranger-$CELLRANGER_VER.tar.gz

RUN \
  cd /opt && \
  tar -xzvf cellranger-$CELLRANGER_VER.tar.gz && \
  export PATH=/opt/cellranger-$CELLRANGER_VER:$PATH && \
  ln -s /opt/cellranger-$CELLRANGER_VER/cellranger /usr/bin/cellranger && \
  rm -rf /opt/cellranger-$CELLRANGER_VER.tar.gz

CMD ["cellranger"]
