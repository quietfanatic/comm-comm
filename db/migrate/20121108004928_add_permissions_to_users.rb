class AddPermissionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :can_edit_topics, :boolean
    add_column :users, :can_confirm_users, :boolean
    add_column :users, :can_edit_users, :boolean
    add_column :users, :can_edit_posts, :boolean
  end
end
