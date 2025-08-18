class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.string :uuid, null: false

      t.string :login, null: false, collation: :NOCASE
      t.string :email, null: false, collation: :NOCASE
      t.string :display_name, null: false

      t.string "persistence_token"
      t.text "bio"
      t.string "avatar"

      t.json "roles", default: [], null: false
      t.boolean "admin", default: false

      t.index :login, unique: true
      t.index :uuid, unique: true
      t.index :email, unique: true
      t.index :persistence_token, unique: true

      t.check_constraint "JSON_TYPE(roles) = 'array'", name: "check_roles_array"

      t.timestamps
    end
  end
end
