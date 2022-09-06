class CreatePodcastHosts < ActiveRecord::Migration[7.0]
  def change
    create_table :podcast_hosts, id: :uuid do |t|
      t.references :profile, null: false, foreign_key: true, type: :uuid
      t.references :podcast, null: false, foreign_key: true, type: :uuid
      t.string :state

      t.timestamps
    end
  end
end
