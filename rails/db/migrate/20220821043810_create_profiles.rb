class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles, id: :uuid do |t|
      t.citext :login, index: true, null: false
      t.citext :email, index: true, null: false
      t.string :display_name, null: false
      t.string :persistence_token, index: true
      t.text :bio
      t.string :avatar

      t.string :roles, array: true, default: []

      t.timestamps
    end
  end
end
