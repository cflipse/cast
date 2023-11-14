FROM ruby:3.2.2-alpine

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
  taglib-dev \
  rsync

# These take longer to build
RUN gem install \
  bootsnap:1.17.0 \
  nio4r:2.5.9 \
  bindex:0.8.1 \
  msgpack:1.7.2 \
  json:2.6.3 \
  pg:1.5.4 \
  taglib-ruby:1.1.3 \
  websocket-driver:0.7.6 \
  debug:1.8.0 \
  puma:6.4.0

ENV BUNDLE_JOBS=4
ENV BUNDLE_PATH=/usr/local/bundle
ENV BUNDLE_BIN=/usr/local/bundle/bin
ENV GEM_HOME=/usr/local/bundle

RUN gem install --default bundler:"~> 2.4" && npm install -g npm@9.2

WORKDIR /srv/cast

copy Gemfile* package*json /srv/cast/

RUN bundle install
RUN npm ci

copy . /srv/cast/

CMD rails server
