class AddDeletedAt < ActiveRecord::Migration[7.0]
  def change
    change_table :episodes do |t|
      t.timestamp :deleted_at, null: true, index: false
    end
  end
end
