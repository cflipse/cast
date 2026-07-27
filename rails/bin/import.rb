#!/usr/bin/env ruby
# frozen_string_literal: true

# Run with: bin/rails runner bin/import.rb
# Assumes db:migrate:sqlite has been run against storage/development_sqlite.sqlite3

class SqliteRecord < ApplicationRecord
  self.abstract_class = true
  connects_to database: { writing: :sqlite, reading: :sqlite }
end

class SqliteProfile < SqliteRecord
  self.table_name = "profiles"
end

class SqlitePodcast < SqliteRecord
  self.table_name = "podcasts"
end

class SqlitePodcastHost < SqliteRecord
  self.table_name = "podcast_hosts"
end

class SqliteEpisode < SqliteRecord
  self.table_name = "episodes"
end

to_array = ->(val) { JSON.dump(Array(val).reject { _1.to_s.empty? }) }
to_object = ->(val) { val && JSON.dump(val) }

# Truncate in FK-safe order
[SqlitePodcastHost, SqliteEpisode].each(&:delete_all)
[SqlitePodcast, SqliteProfile].each(&:delete_all)

source = ApplicationRecord.connection

SqliteRecord.transaction do
  profiles = source.select_all("SELECT * FROM profiles").map do |row|
    row.merge("roles" => to_array.call(row["roles"]))
  end
  SqliteProfile.insert_all(profiles) if profiles.any?

  podcasts = source.select_all("SELECT * FROM podcasts").map do |row|
    row.merge("image_data" => to_object.call(row["image_data"]))
  end
  SqlitePodcast.insert_all(podcasts) if podcasts.any?

  podcast_hosts = source.select_all("SELECT * FROM podcast_hosts").to_a
  SqlitePodcastHost.insert_all(podcast_hosts) if podcast_hosts.any?

  episodes = source.select_all("SELECT * FROM episodes").map do |row|
    row.merge(
      "slugs" => to_array.call(row["slugs"]),
      "audio_data" => to_object.call(row["audio_data"])
    )
  end
  SqliteEpisode.insert_all(episodes) if episodes.any?
end
