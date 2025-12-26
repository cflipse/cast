CREATE TABLE `schema_migrations`(`filename` varchar(255) NOT NULL PRIMARY KEY);
CREATE TABLE `podcasts`(
  `id` varchar(36) NOT NULL UNIQUE PRIMARY KEY,
  `name` text COLLATE nocase NOT NULL,
  `slug` text COLLATE nocase NOT NULL,
  `description` text,
  `explicit` boolean DEFAULT(0) NOT NULL,
  `image_data` jsonb DEFAULT('{}') NOT NULL,
  `tagline` text,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
);
CREATE INDEX `podcasts_slug_index` ON `podcasts`(`slug`);
CREATE TABLE `profiles`(
  `id` varchar(36) NOT NULL UNIQUE PRIMARY KEY,
  `login` text COLLATE nocase NOT NULL,
  `email` text COLLATE nocase NOT NULL,
  `persistence_token` varchar(255),
  `display_name` varchar(255) NOT NULL,
  `bio` text,
  `avatar` text,
  `roles` jsonb DEFAULT('[]') NOT NULL, `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `admin` boolean DEFAULT(0) NOT NULL
);
CREATE INDEX `profiles_login_index` ON `profiles`(`login`);
CREATE INDEX `profiles_email_index` ON `profiles`(`email`);
CREATE INDEX `profiles_persistence_token_index` ON `profiles`(
  `persistence_token`
);
CREATE TABLE `podcast_hosts`(
  `id` varchar(36) NOT NULL UNIQUE PRIMARY KEY,
  `profile_id` varchar(36) NOT NULL REFERENCES `profiles`,
  `podcast_id` varchar(36) NOT NULL REFERENCES `podcasts`,
  `state` varchar(255) COLLATE nocase,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
);
CREATE INDEX `podcast_hosts_profile_id_index` ON `podcast_hosts`(`profile_id`);
CREATE INDEX `podcast_hosts_podcast_id_index` ON `podcast_hosts`(`podcast_id`);
CREATE TABLE `episodes`(
  `id` varchar(36) NOT NULL UNIQUE PRIMARY KEY,
  `podcast_id` varchar(36) NOT NULL REFERENCES `podcasts`,
  `name` varchar(255) COLLATE nocase NOT NULL,
  `number` integer,
  `season` integer,
  `description` text,
  `audio_data` jsonb DEFAULT('{}') NOT NULL,
  `show_notes` text,
  `explicit` boolean DEFAULT(0) NOT NULL,
  `published` datetime NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `deleted_at` datetime NULL,
  `slugs` jsonb DEFAULT('[]') NOT NULL
);
CREATE INDEX `episodes_podcast_id_index` ON `episodes`(`podcast_id`);
CREATE INDEX `episodes_published_index` ON `episodes`(`published`);
INSERT INTO schema_migrations (filename) VALUES
('20251224224626_create_existing.rb');
