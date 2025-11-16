class AddTagline < ActiveRecord::Migration[7.0]
  def change
    add_column :podcasts, :tagline, :string, null: true
  end
end
