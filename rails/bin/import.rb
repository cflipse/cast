#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/setup"
require "json"
require "sequel"
require "pg"
require "sqlite3"

rails_dir = File.expand_path("..", __dir__)

castdb_url = ENV.fetch "CASTS_DB" do
  address = `docker compose --project-directory #{File.expand_path("../..", __dir__)} port castdb 5432`.strip
  raise "castdb isn't running (docker compose up -d castdb)" if address.to_s.empty?

  "postgres://bwoa:rikus@#{address}/casts_development"
end

# Assumes db:migrate:sqlite has been run against storage/development_sqlite.sqlite3.

production = Sequel.connect castdb_url
production.extension :pg_array, :pg_json
production.register_array_type :citext, scalar_typecast: :string

development = Sequel.connect "sqlite://#{rails_dir}/storage/cast.sqlite3"

development[:podcast_hosts].truncate
development[:episodes].truncate
development[:profiles].truncate
development[:podcasts].truncate

clean_array = ->(array) { JSON.dump array.to_a.reject(&:empty?) }
clean_json = ->(hash) { hash && JSON.dump(hash.to_h) }

development.transaction do
  profiles = production[:profiles].all.each do |profile|
    profile[:roles] = clean_array.call(profile[:roles])
  end
  development[:profiles].multi_insert profiles

  podcasts = production[:podcasts].all.each do |podcast|
    podcast[:image_data] = clean_json.call(podcast[:image_data])
  end
  development[:podcasts].multi_insert podcasts

  podcast_hosts = production[:podcast_hosts].all
  development[:podcast_hosts].multi_insert podcast_hosts

  episodes = production[:episodes].all.each do |episode|
    episode[:slugs] = clean_array.call(episode[:slugs])
    episode[:audio_data] = clean_json.call(episode[:audio_data])
  end
  development[:episodes].multi_insert episodes
end
