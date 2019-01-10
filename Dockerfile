FROM jenkins/jnlp-slave:3.27-1-alpine
MAINTAINER Michal Jirman <jirman.michal@gmail.com>

ENV HELM_VERSION v2.12.0
ENV HELM_FILENAME helm-${HELM_VERSION}-linux-amd64.tar.gz
ENV KUBERNETES_VERSION v1.13.1
ENV DOCKER_VERSION 18.09.1

ARG VCS_REF
ARG BUILD_DATE

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/michaljirman/jenkins-jnlp-slave" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile"

USER root
WORKDIR /
RUN apk add --update -t deps curl tar gzip ca-certificates git

# The latest dependencies
# Install Docker
#RUN apt-get -qq update && \
#    apt-get -qq -y install curl && \
#    curl -sSL https://get.docker.com/ | sh
# Install kubectl and helm
#RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
#    chmod +x ./kubectl && \
#    mv ./kubectl /usr/local/bin/kubectl && \
#    curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

RUN curl -L http://storage.googleapis.com/kubernetes-helm/${HELM_FILENAME} | tar zxv -C /tmp \
  && cp /tmp/linux-amd64/helm /usr/local/bin/helm \
  && chmod +x /usr/local/bin/helm

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl

RUN curl -L https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz | tar zxv -C /tmp \
 && cp /tmp/docker/docker /usr/local/bin/docker \
 && chmod +x /usr/local/bin/docker

RUN apk del --purge deps

RUN apk add --update mysql-client \
 && rm /var/cache/apk/*

USER jenkins
RUN helm init --client-only
