arg version=3.4.5-alpine

FROM ruby:${version} as base
WORKDIR /srv/cast

RUN apk add --no-cache \
  busybox \
  ca-certificates \
  file \
  curl \
  graphicsmagick \
  postgresql \
  tzdata \
  taglib \
  yaml \
  rsync

ENV BUNDLE_JOBS=4 \
    BUNDLE_PATH=/usr/local/bundle \
    GEM_HOME=/usr/local/bundle

CMD bin/rails server

FROM base AS development

RUN apk add --no-cache \
  build-base \
  git \
  libffi-dev \
  libsodium-dev \
  nodejs \
  npm \
  yaml-dev \
  postgresql-dev \
  taglib-dev

# These take longer to build
RUN gem install \
  bootsnap:1.18.6 \
  nio4r:2.7.4 \
  bindex:0.8.1 \
  msgpack:1.8.0 \
  json:2.13.2 \
  pg:1.6.1 \
  taglib-ruby:2.0.0 \
  websocket-driver:0.8.0 \
  debug:1.11.0 \
  puma:6.6.1

RUN gem install --default bundler:"~> 2.7.1" && npm install -g npm@11.5.2

WORKDIR /srv/cast
EXPOSE 6700

COPY Gemfile* package*json /srv/cast/

RUN bundle install
RUN npm ci


FROM development AS assets
ENV RAILS_ENV=production

COPY . .

RUN npx vite build

FROM base AS production
EXPOSE 6700
COPY . .

COPY --from=assets /usr/local/bundle /usr/local/bundle
COPY --from=assets /srv/cast/public /srv/cast/public

ENTRYPOINT ["bin/docker-entrypoint"]
CMD ["./bin/rails", "server"]
