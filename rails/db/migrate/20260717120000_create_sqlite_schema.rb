class CreateSqliteSchema < ActiveRecord::Migration[8.0]
  def change
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

      t.index :email
      t.index :login
      t.index :persistence_token
    end

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

      t.index :slug
    end

    create_table :podcast_hosts, id: false do |t|
      t.string :id, primary_key: true
      t.string :profile_id, null: false
      t.string :podcast_id, null: false
      t.string :state, collation: "NOCASE"
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false

      t.index :profile_id
      t.index :podcast_id
    end

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

      t.index :podcast_id
      t.index :published
    end

    add_foreign_key :episodes, :podcasts
    add_foreign_key :podcast_hosts, :podcasts
    add_foreign_key :podcast_hosts, :profiles
  end
end
