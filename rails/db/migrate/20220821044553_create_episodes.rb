class CreateEpisodes < ActiveRecord::Migration[7.0]
  def change
    create_table :episodes, id: :uuid do |t|
      t.string :name
      t.integer :number
      t.integer :season
      t.text :description

      t.references :podcast, null: false, foreign_key: true, type: :uuid
      t.jsonb :audio_data

      t.boolean :explicit, null: true

      t.text :show_notes

      t.timestamp :published, index: true
      t.timestamps
    end
  end
end
