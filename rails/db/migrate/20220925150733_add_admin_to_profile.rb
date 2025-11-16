class AddAdminToProfile < ActiveRecord::Migration[7.0]
  def change
    change_table :profiles do |t|
      t.boolean :admin, default: false
    end
  end
end
