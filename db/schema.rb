# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_11_12_170101) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "hstore"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "episodes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.citext "name"
    t.integer "number"
    t.integer "season"
    t.text "description"
    t.uuid "podcast_id", null: false
    t.jsonb "audio_data"
    t.boolean "explicit"
    t.text "show_notes"
    t.datetime "published", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at", precision: nil
    t.index ["podcast_id"], name: "index_episodes_on_podcast_id"
    t.index ["published"], name: "index_episodes_on_published"
  end

  create_table "podcast_hosts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "profile_id", null: false
    t.uuid "podcast_id", null: false
    t.citext "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["podcast_id"], name: "index_podcast_hosts_on_podcast_id"
    t.index ["profile_id"], name: "index_podcast_hosts_on_profile_id"
  end

  create_table "podcasts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.citext "name", null: false
    t.citext "slug", null: false
    t.text "description"
    t.boolean "explicit", null: false
    t.jsonb "image_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tagline"
    t.index ["slug"], name: "index_podcasts_on_slug"
  end

  create_table "profiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.citext "login", null: false
    t.citext "email", null: false
    t.string "display_name", null: false
    t.string "persistence_token"
    t.text "bio"
    t.string "avatar"
    t.string "roles", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_profiles_on_email"
    t.index ["login"], name: "index_profiles_on_login"
    t.index ["persistence_token"], name: "index_profiles_on_persistence_token"
  end

  create_table "versions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "episodes", "podcasts"
  add_foreign_key "podcast_hosts", "podcasts"
  add_foreign_key "podcast_hosts", "profiles"
end
