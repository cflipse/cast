arg version=3.3.4-alpine

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
  rsync

ENV BUNDLE_JOBS=4 \
    BUNDLE_PATH=/usr/local/bundle \
    GEM_HOME=/usr/local/bundle

CMD bin/rails server

FROM base as development

RUN apk add --no-cache \
  build-base \
  git \
  libffi-dev \
  libsodium-dev \
  nodejs \
  npm \
  postgresql-dev \
  taglib-dev

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

RUN gem install --default bundler:"~> 2.4" && npm install -g npm@9.2

WORKDIR /srv/cast
EXPOSE 6700

COPY Gemfile* package*json /srv/cast/

RUN bundle install
RUN npm ci


FROM development as assets
ENV RAILS_ENV=production

COPY . .

RUN SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile

from base as production
EXPOSE 6700
COPY . .

COPY --from=assets /usr/local/bundle /usr/local/bundle
COPY --from=assets /srv/cast/public /srv/cast/public

ENTRYPOINT ["bin/docker-entrypoint"]
CMD ["./bin/rails", "server"]
