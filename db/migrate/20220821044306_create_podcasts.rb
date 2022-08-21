class CreatePodcasts < ActiveRecord::Migration[7.0]
  def change
    create_table :podcasts, id: :uuid do |t|
      t.string :name, null: false
      t.citext :slug, index: true, null: false
      t.text :description

      t.boolean :explicit, null: false
      t.jsonb :image_data

      t.timestamps
    end
  end
end
