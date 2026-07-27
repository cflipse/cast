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

ActiveRecord::Schema[8.0].define(version: 2026_07_17_120000) do
  create_table "_litestream_lock", id: false, force: :cascade do |t|
    t.integer "id"
  end

  create_table "_litestream_seq", id: :integer, default: nil, force: :cascade do |t|
    t.integer "seq"
  end

  create_table "episodes", id: :string, force: :cascade do |t|
    t.string "name", collation: "NOCASE"
    t.integer "number"
    t.integer "season"
    t.text "description"
    t.string "podcast_id", null: false
    t.json "audio_data"
    t.boolean "explicit"
    t.text "show_notes"
    t.datetime "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.json "slugs", default: [], null: false
    t.index ["podcast_id"], name: "index_episodes_on_podcast_id"
    t.index ["published"], name: "index_episodes_on_published"
  end

  create_table "podcast_hosts", id: :string, force: :cascade do |t|
    t.string "profile_id", null: false
    t.string "podcast_id", null: false
    t.string "state", collation: "NOCASE"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["podcast_id"], name: "index_podcast_hosts_on_podcast_id"
    t.index ["profile_id"], name: "index_podcast_hosts_on_profile_id"
  end

  create_table "podcasts", id: :string, force: :cascade do |t|
    t.string "name", null: false, collation: "NOCASE"
    t.string "slug", null: false, collation: "NOCASE"
    t.text "description"
    t.boolean "explicit", null: false
    t.json "image_data"
    t.string "tagline"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_podcasts_on_slug"
  end

  create_table "profiles", id: :string, force: :cascade do |t|
    t.string "login", null: false, collation: "NOCASE"
    t.string "email", null: false, collation: "NOCASE"
    t.string "display_name", null: false
    t.string "persistence_token"
    t.text "bio"
    t.string "avatar"
    t.json "roles", default: [], null: false
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_profiles_on_email"
    t.index ["login"], name: "index_profiles_on_login"
    t.index ["persistence_token"], name: "index_profiles_on_persistence_token"
  end

  add_foreign_key "episodes", "podcasts"
  add_foreign_key "podcast_hosts", "podcasts"
  add_foreign_key "podcast_hosts", "profiles"
end
