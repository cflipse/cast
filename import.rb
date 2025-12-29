#!/usr/bin/env ruby

require "bundler/inline"
require "json"

gemfile do
  gem "sequel"
  gem "pg"
  gem "sqlite3"
  gem "pry"
end

production = Sequel.connect ENV["PROD_DB"] + "/casts_production"
development = Sequel.connect "sqlite://#{__dir__}/hanami/db/casts.sqlite"

development[:podcast_hosts].truncate
development[:profiles].truncate
development[:podcasts].truncate
development[:episodes].truncate

development.transaction do
  production[:profiles].all.each do |profile|
    profile[:roles] = JSON.dump profile[:roles].gsub(/[{}"]/, "").split(",").reject(&:empty?)
    profile[:uuid] = profile.delete :id
  end.then { pp it }.then { development[:profiles].multi_insert it }

  production[:podcasts].all.each do |podcast|
    podcast[:uuid] = podcast.delete :id
  end.then { development[:podcasts].multi_insert it }

  production[:podcast_hosts].all.each do |ph|
    ph[:uuid] = ph.delete :id
  end.then { development[:podcast_hosts].multi_insert it }

  production[:episodes].all.each do |episode|
    episode[:slugs] = JSON.dump episode[:slugs].gsub(/[{}"]/, "").split(",").reject(&:empty?)
    episode[:uuid] = episode.delete :id
  end.then { development[:episodes].multi_insert it }
end
