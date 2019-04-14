# syntax=docker/dockerfile:1.0.0-experimental
FROM base as dependencies
FROM ubuntu:18.04

ARG REPO_URL
ARG BRANCH
ENV REPO_URL=$REPO_URL
ENV BRANCH=$BRANCH

RUN apt-get update -y && apt-get install -y \
  build-essential openssl \
  libffi-dev libxslt-dev libxml2 \
  postgresql-client \
  git bash curl jq

WORKDIR /src

RUN mkdir -p -m 0600 ~/.ssh && \
  ssh-keyscan github.com >> ~/.ssh/known_hosts

RUN --mount=type=ssh git clone $REPO_URL . && \
  git checkout $BRANCH

COPY steps /steps
COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
