CREATE TABLE IF NOT EXISTS "ar_internal_metadata"(
  "key" varchar NOT NULL PRIMARY KEY,
  "value" varchar,
  "created_at" datetime(6) NOT NULL,
  "updated_at" datetime(6) NOT NULL
);
CREATE TABLE _litestream_seq(id INTEGER PRIMARY KEY, seq INTEGER);
CREATE TABLE _litestream_lock(id INTEGER);
CREATE TABLE `schema_migrations`(`filename` varchar(255) NOT NULL PRIMARY KEY);
CREATE TABLE `podcasts`(
  `id` varchar(255) DEFAULT(NULL) NOT NULL UNIQUE PRIMARY KEY,
  `name` varchar(255) DEFAULT(NULL) NOT NULL,
  `slug` varchar(255) DEFAULT(NULL) NOT NULL,
  `description` TEXT DEFAULT(NULL) NULL,
  `explicit` boolean DEFAULT(NULL) NOT NULL,
  `image_data` json DEFAULT(NULL) NULL,
  `tagline` varchar(255) DEFAULT(NULL) NULL,
  `created_at` datetime(6) DEFAULT(datetime(CURRENT_TIMESTAMP, 'localtime')) NOT NULL,
  `updated_at` datetime(6) DEFAULT(datetime(CURRENT_TIMESTAMP, 'localtime')) NOT NULL
);
CREATE INDEX `index_podcasts_on_slug` ON `podcasts`(`slug`);
CREATE TABLE `profiles`(
  `id` varchar(255) DEFAULT(NULL) NOT NULL UNIQUE PRIMARY KEY,
  `login` varchar(255) DEFAULT(NULL) NOT NULL,
  `email` varchar(255) DEFAULT(NULL) NOT NULL,
  `display_name` varchar(255) DEFAULT(NULL) NOT NULL,
  `persistence_token` varchar(255) DEFAULT(NULL) NULL,
  `bio` TEXT DEFAULT(NULL) NULL,
  `avatar` varchar(255) DEFAULT(NULL) NULL,
  `roles` json DEFAULT('[]') NOT NULL, `admin` boolean DEFAULT(0) NULL,
  `created_at` datetime(6) DEFAULT(datetime(CURRENT_TIMESTAMP, 'localtime')) NOT NULL,
  `updated_at` datetime(6) DEFAULT(datetime(CURRENT_TIMESTAMP, 'localtime')) NOT NULL
);
CREATE INDEX `index_profiles_on_email` ON `profiles`(`email`);
CREATE INDEX `index_profiles_on_login` ON `profiles`(`login`);
CREATE INDEX `index_profiles_on_persistence_token` ON `profiles`(
  `persistence_token`
);
CREATE TABLE `episodes`(
  `id` varchar(255) DEFAULT(NULL) NOT NULL UNIQUE PRIMARY KEY,
  `name` varchar(255) DEFAULT(NULL) NULL,
  `number` INTEGER DEFAULT(NULL) NULL,
  `season` INTEGER DEFAULT(NULL) NULL,
  `description` TEXT DEFAULT(NULL) NULL,
  `podcast_id` varchar(255) DEFAULT(NULL) NOT NULL,
  `audio_data` json DEFAULT(NULL) NULL,
  `explicit` boolean DEFAULT(NULL) NULL,
  `show_notes` TEXT DEFAULT(NULL) NULL,
  `published` datetime(6) DEFAULT(NULL) NULL,
  `created_at` datetime(6) DEFAULT(datetime(CURRENT_TIMESTAMP, 'localtime')) NOT NULL,
  `updated_at` datetime(6) DEFAULT(datetime(CURRENT_TIMESTAMP, 'localtime')) NOT NULL,
  `deleted_at` datetime(6) DEFAULT(NULL) NULL,
  `slugs` json DEFAULT('[]') NOT NULL, FOREIGN KEY(`podcast_id`) REFERENCES `podcasts`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX `index_episodes_on_podcast_id` ON `episodes`(`podcast_id`);
CREATE INDEX `index_episodes_on_published` ON `episodes`(`published`);
CREATE TABLE `podcast_hosts`(
  `id` varchar(255) DEFAULT(NULL) NOT NULL UNIQUE PRIMARY KEY,
  `profile_id` varchar(255) DEFAULT(NULL) NOT NULL,
  `podcast_id` varchar(255) DEFAULT(NULL) NOT NULL,
  `state` varchar(255) DEFAULT(NULL) NULL,
  `created_at` datetime(6) DEFAULT(datetime(CURRENT_TIMESTAMP, 'localtime')) NOT NULL,
  `updated_at` datetime(6) DEFAULT(datetime(CURRENT_TIMESTAMP, 'localtime')) NOT NULL,
  FOREIGN KEY(`podcast_id`) REFERENCES `podcasts`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY(`profile_id`) REFERENCES `profiles`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX `index_podcast_hosts_on_podcast_id` ON `podcast_hosts`(
  `podcast_id`
);
CREATE INDEX `index_podcast_hosts_on_profile_id` ON `podcast_hosts`(
  `profile_id`
);
INSERT INTO schema_migrations (filename) VALUES
('20260728164117_initial.rb'),
('20260729141803_timestamps.rb');
