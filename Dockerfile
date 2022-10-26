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
  taglib-dev \
  rsync

# These take longer to build
RUN gem install \
  bootsnap:1.13.0 \
  nio4r:2.5.8 \
  bindex:0.8.1 \
  msgpack:1.6.0 \
  json:2.6.2 \
  pg:1.4.4 \
  taglib-ruby:1.1.2 \
  websocket-driver:0.7.5 \
  debug:1.6.2 \
  puma:5.6.5

ENV BUNDLE_JOBS=4
ENV BUNDLE_PATH=/usr/local/bundle
ENV BUNDLE_BIN=/usr/local/bundle/bin
ENV GEM_HOME=/usr/local/bundle

RUN gem install --default bundler:"~> 2.3" && npm install -g npm@7.24

WORKDIR /srv/cast

copy Gemfile* package*json /srv/cast/

RUN bundle install
RUN npm ci

copy . /srv/cast/

CMD rails server
