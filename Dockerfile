FROM ruby:3.1.2-alpine

RUN apk add --no-cache \
  build-base \
  busybox \
  ca-certificates \
  curl \
  git \
  graphicsmagick \
  libffi-dev \
  libsodium-dev \
  nodejs \
  npm \
  openssh-client \
  postgresql-dev \
  tzdata \
  rsync

ENV BUNDLE_JOBS=4
ENV BUNDLE_PATH=/usr/local/bundle
ENV BUNDLE_BIN=/usr/local/bundle/bin
ENV GEM_HOME=/usr/local/bundle

RUN gem install --default bundler:"~> 2.3" && npm install -g npm@7.24

WORKDIR /srv/casts
