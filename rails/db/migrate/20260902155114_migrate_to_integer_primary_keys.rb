class MigrateToIntegerPrimaryKeys < ActiveRecord::Migration[8.0]
  def up
    disable_referential_integrity do
      migrate_profiles_up
      migrate_podcasts_up
      migrate_podcast_hosts_up
      migrate_episodes_up
    end
  end

  def down
    disable_referential_integrity do
      # Data must be unwound child-first (episodes/podcast_hosts need their
      # parents' still-up-state integer id + uuid to remap FKs back to
      # strings). But foreign keys must NOT be (re)established until every
      # table has reached its final, permanent name -- SQLite's rename_table
      # rewrites REFERENCES clauses in *other* tables when the referenced
      # table is renamed, so any FK added while a parent is mid-rebuild ends
      # up pointing at that parent's transient rename (e.g. "new_podcasts")
      # instead of its final name. So: rebuild all tables first, then add
      # every foreign key in one final pass.
      migrate_episodes_down
      migrate_podcast_hosts_down
      migrate_podcasts_down
      migrate_profiles_down

      add_foreign_key :episodes, :podcasts
      add_foreign_key :podcast_hosts, :podcasts
      add_foreign_key :podcast_hosts, :profiles
    end
  end

  private

  # profiles: string id -> integer id, preserving the old id in a permanent,
  # unique-indexed `uuid` column (profiles are looked up publicly by uuid).
  def migrate_profiles_up
    rename_table :profiles, :old_profiles

    create_table :profiles do |t|
      t.string :uuid, null: false
      t.string :login, null: false, collation: "NOCASE"
      t.string :email, null: false, collation: "NOCASE"
      t.string :display_name, null: false
      t.string :persistence_token
      t.text :bio
      t.string :avatar
      t.json :roles, default: [], null: false
      t.boolean :admin, default: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    execute <<~SQL
      INSERT INTO profiles
        (uuid, login, email, display_name, persistence_token, bio, avatar, roles, admin, created_at, updated_at)
      SELECT
        id, login, email, display_name, persistence_token, bio, avatar, roles, admin, created_at, updated_at
      FROM old_profiles
    SQL

    add_index :profiles, :uuid, unique: true
    add_index :profiles, :email
    add_index :profiles, :login
    add_index :profiles, :persistence_token

    drop_table :old_profiles
  end

  def migrate_profiles_down
    rename_table :profiles, :new_profiles

    create_table :profiles, id: false do |t|
      t.string :id, primary_key: true
      t.string :login, null: false, collation: "NOCASE"
      t.string :email, null: false, collation: "NOCASE"
      t.string :display_name, null: false
      t.string :persistence_token
      t.text :bio
      t.string :avatar
      t.json :roles, default: [], null: false
      t.boolean :admin, default: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    execute <<~SQL
      INSERT INTO profiles
        (id, login, email, display_name, persistence_token, bio, avatar, roles, admin, created_at, updated_at)
      SELECT
        uuid, login, email, display_name, persistence_token, bio, avatar, roles, admin, created_at, updated_at
      FROM new_profiles
    SQL

    add_index :profiles, :email
    add_index :profiles, :login
    add_index :profiles, :persistence_token

    drop_table :new_profiles
  end

  # podcasts: string id -> integer id. podcasts are never looked up publicly by
  # uuid (Podcast#to_param uses :slug), so the `uuid` column here is
  # transitional only -- kept just to remap podcast_hosts/episodes foreign
  # keys during this migration and to support a reversible `down`. No unique
  # index; not exposed anywhere in app code. Candidate for removal in a
  # future follow-up migration.
  def migrate_podcasts_up
    rename_table :podcasts, :old_podcasts

    create_table :podcasts do |t|
      # nullable: transitional column, not populated for new records (see
      # class-level comment above)
      t.string :uuid
      t.string :name, null: false, collation: "NOCASE"
      t.string :slug, null: false, collation: "NOCASE"
      t.text :description
      t.boolean :explicit, null: false
      t.json :image_data
      t.string :tagline
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    execute <<~SQL
      INSERT INTO podcasts
        (uuid, name, slug, description, explicit, image_data, tagline, created_at, updated_at)
      SELECT
        id, name, slug, description, explicit, image_data, tagline, created_at, updated_at
      FROM old_podcasts
    SQL

    add_index :podcasts, :slug

    drop_table :old_podcasts
  end

  def migrate_podcasts_down
    rename_table :podcasts, :new_podcasts

    create_table :podcasts, id: false do |t|
      t.string :id, primary_key: true
      t.string :name, null: false, collation: "NOCASE"
      t.string :slug, null: false, collation: "NOCASE"
      t.text :description
      t.boolean :explicit, null: false
      t.json :image_data
      t.string :tagline
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    execute <<~SQL
      INSERT INTO podcasts
        (id, name, slug, description, explicit, image_data, tagline, created_at, updated_at)
      SELECT
        uuid, name, slug, description, explicit, image_data, tagline, created_at, updated_at
      FROM new_podcasts
    SQL

    add_index :podcasts, :slug

    drop_table :new_podcasts
  end

  # podcast_hosts: string id -> integer id, FKs remapped from the old string
  # uuid values to the new parent integer ids via a join on each parent's
  # uuid column. Never looked up publicly by uuid, so `uuid` here is also
  # transitional-only (same rationale as podcasts, see above).
  def migrate_podcast_hosts_up
    rename_table :podcast_hosts, :old_podcast_hosts

    create_table :podcast_hosts do |t|
      # nullable: transitional column, not populated for new records (see
      # class-level comment above)
      t.string :uuid
      t.integer :profile_id, null: false
      t.integer :podcast_id, null: false
      t.string :state, collation: "NOCASE"
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    execute <<~SQL
      INSERT INTO podcast_hosts
        (uuid, profile_id, podcast_id, state, created_at, updated_at)
      SELECT
        oph.id, p.id, pc.id, oph.state, oph.created_at, oph.updated_at
      FROM old_podcast_hosts oph
      JOIN profiles p ON p.uuid = oph.profile_id
      JOIN podcasts pc ON pc.uuid = oph.podcast_id
    SQL

    add_index :podcast_hosts, :profile_id
    add_index :podcast_hosts, :podcast_id

    add_foreign_key :podcast_hosts, :profiles
    add_foreign_key :podcast_hosts, :podcasts

    drop_table :old_podcast_hosts
  end

  def migrate_podcast_hosts_down
    rename_table :podcast_hosts, :new_podcast_hosts

    create_table :podcast_hosts, id: false do |t|
      t.string :id, primary_key: true
      t.string :profile_id, null: false
      t.string :podcast_id, null: false
      t.string :state, collation: "NOCASE"
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    execute <<~SQL
      INSERT INTO podcast_hosts
        (id, profile_id, podcast_id, state, created_at, updated_at)
      SELECT
        nph.uuid, p.uuid, pc.uuid, nph.state, nph.created_at, nph.updated_at
      FROM new_podcast_hosts nph
      JOIN profiles p ON p.id = nph.profile_id
      JOIN podcasts pc ON pc.id = nph.podcast_id
    SQL

    add_index :podcast_hosts, :profile_id
    add_index :podcast_hosts, :podcast_id

    drop_table :new_podcast_hosts
  end

  # episodes: string id -> integer id, preserving the old id in a permanent,
  # unique-indexed `uuid` column (episodes are looked up publicly by uuid --
  # see Episode#slug and EpisodesController#show). podcast_id is remapped
  # from the old string uuid to the new parent integer id via a join.
  def migrate_episodes_up
    rename_table :episodes, :old_episodes

    create_table :episodes do |t|
      t.string :uuid, null: false
      t.string :name, collation: "NOCASE"
      t.integer :number
      t.integer :season
      t.text :description
      t.integer :podcast_id, null: false
      t.json :audio_data
      t.boolean :explicit
      t.text :show_notes
      t.datetime :published
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.datetime :deleted_at
      t.json :slugs, default: [], null: false
    end

    execute <<~SQL
      INSERT INTO episodes
        (uuid, name, number, season, description, podcast_id, audio_data, explicit,
         show_notes, published, created_at, updated_at, deleted_at, slugs)
      SELECT
        oe.id, oe.name, oe.number, oe.season, oe.description, pc.id, oe.audio_data, oe.explicit,
        oe.show_notes, oe.published, oe.created_at, oe.updated_at, oe.deleted_at, oe.slugs
      FROM old_episodes oe
      JOIN podcasts pc ON pc.uuid = oe.podcast_id
    SQL

    add_index :episodes, :uuid, unique: true
    add_index :episodes, :podcast_id
    add_index :episodes, :published

    add_foreign_key :episodes, :podcasts

    drop_table :old_episodes
  end

  def migrate_episodes_down
    rename_table :episodes, :new_episodes

    create_table :episodes, id: false do |t|
      t.string :id, primary_key: true
      t.string :name, collation: "NOCASE"
      t.integer :number
      t.integer :season
      t.text :description
      t.string :podcast_id, null: false
      t.json :audio_data
      t.boolean :explicit
      t.text :show_notes
      t.datetime :published
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.datetime :deleted_at
      t.json :slugs, default: [], null: false
    end

    execute <<~SQL
      INSERT INTO episodes
        (id, name, number, season, description, podcast_id, audio_data, explicit,
         show_notes, published, created_at, updated_at, deleted_at, slugs)
      SELECT
        ne.uuid, ne.name, ne.number, ne.season, ne.description, pc.uuid, ne.audio_data, ne.explicit,
        ne.show_notes, ne.published, ne.created_at, ne.updated_at, ne.deleted_at, ne.slugs
      FROM new_episodes ne
      JOIN podcasts pc ON pc.id = ne.podcast_id
    SQL

    add_index :episodes, :podcast_id
    add_index :episodes, :published

    drop_table :new_episodes
  end
end
