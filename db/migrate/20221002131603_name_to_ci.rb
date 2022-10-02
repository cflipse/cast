class NameToCi < ActiveRecord::Migration[7.0]
  def up
    change_column :episodes, :name, :citext
    change_column :podcast_hosts, :state, :citext
    change_column :podcasts, :name, :citext
  end

  def down
    change_column :episodes, :name, :string
    change_column :podcasts, :name, :string
    change_column :podcast_hosts, :state, :string
  end
end
