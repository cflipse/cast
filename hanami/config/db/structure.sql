CREATE TABLE IF NOT EXISTS "podcasts"(
  "id" varchar NOT NULL PRIMARY KEY,
  "name" varchar COLLATE "NOCASE" NOT NULL,
  "slug" varchar COLLATE "NOCASE" NOT NULL,
  "description" text,
  "explicit" boolean NOT NULL,
  "image_data" json,
  "tagline" varchar,
  "created_at" datetime(6) NOT NULL,
  "updated_at" datetime(6) NOT NULL
);
CREATE INDEX "index_podcasts_on_slug" ON "podcasts"("slug");
CREATE TABLE IF NOT EXISTS "profiles"(
  "id" varchar NOT NULL PRIMARY KEY,
  "login" varchar COLLATE "NOCASE" NOT NULL,
  "email" varchar COLLATE "NOCASE" NOT NULL,
  "display_name" varchar NOT NULL,
  "persistence_token" varchar,
  "bio" text,
  "avatar" varchar,
  "roles" json DEFAULT '[]' NOT NULL, "admin" boolean DEFAULT 0,
  "created_at" datetime(6) NOT NULL,
  "updated_at" datetime(6) NOT NULL
);
CREATE INDEX "index_profiles_on_email" ON "profiles"("email");
CREATE INDEX "index_profiles_on_login" ON "profiles"("login");
CREATE INDEX "index_profiles_on_persistence_token" ON "profiles"(
  "persistence_token"
);
CREATE TABLE IF NOT EXISTS "episodes"(
  "id" varchar NOT NULL PRIMARY KEY,
  "name" varchar COLLATE "NOCASE",
  "number" integer,
  "season" integer,
  "description" text,
  "podcast_id" varchar NOT NULL,
  "audio_data" json,
  "explicit" boolean,
  "show_notes" text,
  "published" datetime(6),
  "created_at" datetime(6) NOT NULL,
  "updated_at" datetime(6) NOT NULL,
  "deleted_at" datetime(6),
  "slugs" json DEFAULT '[]' NOT NULL, CONSTRAINT "fk_rails_77002f9ee3"
  FOREIGN KEY("podcast_id")
  REFERENCES "podcasts"("id")
);
CREATE INDEX "index_episodes_on_podcast_id" ON "episodes"("podcast_id");
CREATE INDEX "index_episodes_on_published" ON "episodes"("published");
CREATE TABLE IF NOT EXISTS "podcast_hosts"(
  "id" varchar NOT NULL PRIMARY KEY,
  "profile_id" varchar NOT NULL,
  "podcast_id" varchar NOT NULL,
  "state" varchar COLLATE "NOCASE",
  "created_at" datetime(6) NOT NULL,
  "updated_at" datetime(6) NOT NULL,
  CONSTRAINT "fk_rails_637ea09143"
  FOREIGN KEY("podcast_id")
  REFERENCES "podcasts"("id")
  ,
  CONSTRAINT "fk_rails_5f308865b6"
  FOREIGN KEY("profile_id")
  REFERENCES "profiles"("id")
);
CREATE INDEX "index_podcast_hosts_on_podcast_id" ON "podcast_hosts"(
  "podcast_id"
);
CREATE INDEX "index_podcast_hosts_on_profile_id" ON "podcast_hosts"(
  "profile_id"
);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata"(
  "key" varchar NOT NULL PRIMARY KEY,
  "value" varchar,
  "created_at" datetime(6) NOT NULL,
  "updated_at" datetime(6) NOT NULL
);
CREATE TABLE _litestream_seq(id INTEGER PRIMARY KEY, seq INTEGER);
CREATE TABLE _litestream_lock(id INTEGER);
CREATE TABLE `schema_migrations`(`filename` varchar(255) NOT NULL PRIMARY KEY);
INSERT INTO schema_migrations (filename) VALUES
('20260728164117_initial.rb');
