class AddEpisodeSlugs < ActiveRecord::Migration[7.0]
  def change
    change_table :episodes do |t|
      t.citext :slugs, array: true, null: false, default: []
    end
    add_index :episodes, :slugs, using: 'gin'
  end
end
