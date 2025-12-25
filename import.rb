#!/usr/bin/env ruby

require 'bundler/inline'
require "json"

gemfile do
  gem "sequel"
  gem "pg"
  gem "sqlite3"
  gem "pry"
end


production = Sequel.connect ENV['PROD_DB'] + "/casts_production"
development = Sequel.connect "sqlite://hanami/db/casts.sqlite"

development[:podcast_hosts].truncate
development[:profiles].truncate
development[:podcasts].truncate
development[:episodes].truncate

production[:profiles].each do |profile|
  profile[:roles] = JSON.dump profile[:roles].gsub(/[{}"]/, '').split(',').reject(&:empty?)

  development[:profiles].insert profile
end

production[:podcasts].each do |podcast|
  development[:podcasts].insert podcast
end

production[:podcast_hosts].each do |host|
  development[:podcast_hosts].insert host
end

production[:episodes].each do |episode|
  episode[:slugs] = JSON.dump episode[:slugs].gsub(/[{}"]/, '').split(',').reject(&:empty?)

  development[:episodes].insert episode
end
