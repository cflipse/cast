arg version=4.0.7-alpine

FROM ruby:${version} AS base
WORKDIR /srv/cast

RUN apk add --no-cache \
  busybox \
  ca-certificates \
  file \
  curl \
  tzdata \
  taglib \
  yaml \
  rsync

ENV BUNDLE_JOBS=4 \
    BUNDLE_PATH=/usr/local/bundle \
    GEM_HOME=/usr/local/bundle

CMD ["./bin/hanami", "server"]

FROM base AS development

RUN apk add --no-cache \
  build-base \
  libffi-dev \
  nodejs \
  npm \
  taglib-dev

# These take longer to build
RUN gem install \
  json:3.0.2 \
  taglib-ruby:2.0.0 \
  puma:8.0.2

RUN gem install --default bundler:"~> 4.0.11" && npm install -g npm@11.5.2 --ignore-scripts

WORKDIR /srv/cast
EXPOSE 2300
ENV RACK_ENV=development

COPY Gemfile* package*json /srv/cast/

RUN bundle install
RUN npm ci --ignore-scripts

FROM development AS assets
ENV RACK_ENV=production

COPY . .

RUN npx vite build

FROM base AS production
EXPOSE 2300
COPY . .

COPY --from=assets /usr/local/bundle /usr/local/bundle
COPY --from=assets /srv/cast/public /srv/cast/public

ENTRYPOINT ["bin/docker-entrypoint"]
