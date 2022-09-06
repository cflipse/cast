class EnableExtensions < ActiveRecord::Migration[7.0]
  def change
    enable_extension :citext
    enable_extension :hstore
    enable_extension :pgcrypto
  end
end
