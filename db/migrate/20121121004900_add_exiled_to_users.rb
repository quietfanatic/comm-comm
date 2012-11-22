class AddExiledToUsers < ActiveRecord::Migration
  def change
    add_column :users, :exiled, :boolean
  end
end
