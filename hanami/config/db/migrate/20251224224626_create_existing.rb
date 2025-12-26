# frozen_string_literal: true

ROM::SQL.migration do
  # Add your migration here.
  #
  # See https://guides.hanamirb.org/v2.2/database/migrations/ for details.
  change do
    create_table :podcasts do
      column :id, "varchar(36)", null: false, primary_key: true, unique: true
      column :name, :text, null: false, collate: :nocase
      column :slug, :text, null: false, collate: :nocase, index: true
      column :description, :text
      column :explicit, :boolean, null: false, default: false
      column :image_data, :jsonb, null: false, default: "{}"
      column :tagline, :text

      column :created_at, :datetime, null: false
      column :updated_at, :datetime, null: false
    end

    create_table :profiles do
      column :id, "varchar(36)", null: false, primary_key: true, unique: true
      column :login, :text, null: false, collate: :nocase, index: true
      column :email, :text, null: false, collate: :nocase, index: true

      column :persistence_token, String, index: true

      column :display_name, String, null: false
      column :bio, :text
      column :avatar, :text

      column :roles, :jsonb, null: false, default: "[]"

      column :created_at, :datetime, null: false
      column :updated_at, :datetime, null: false
      column :admin, :boolean, null: false, default: false
    end

    create_table :podcast_hosts do
      column :id, "varchar(36)", null: false, primary_key: true, unique: true
      foreign_key :profile_id, :profiles, type: "varchar(36)", null: false, index: true
      foreign_key :podcast_id, :podcasts, type: "varchar(36)", null: false, index: true

      column :state, String, collate: :nocase
      column :created_at, :datetime, null: false
      column :updated_at, :datetime, null: false
    end

    create_table :episodes do
      column :id, "varchar(36)", null: false, primary_key: true, unique: true
      foreign_key :podcast_id, :podcasts, type: "varchar(36)", null: false, index: true

      column :name, String, null: false, collate: :nocase
      column :number, Integer
      column :season, Integer
      column :description, :text
      column :audio_data, :jsonb, default: "{}", null: false
      column :show_notes, :text
      column :explicit, :boolean, null: false, default: false

      column :published, :datetime, null: true, index: true
      column :created_at, :datetime, null: false
      column :updated_at, :datetime, null: false
      column :deleted_at, :datetime, null: true

      # NOTE: elements in here can't be directly indexed in sqlite; figure out
      # the function, or denormalize these.  Included like this for parity with the
      # existing db structure
      column :slugs, :jsonb, default: "[]", null: false
    end
  end
end
