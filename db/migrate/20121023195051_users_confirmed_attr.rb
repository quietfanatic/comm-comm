class UsersConfirmedAttr < ActiveRecord::Migration
  def up
    add_column :users, :is_confirmed, :boolean
  end

  def down
    remove_column :users, :is_confirmed
  end
end
