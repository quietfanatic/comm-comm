class RenameUserInTopicUsers < ActiveRecord::Migration
  def change
    rename_column :topic_users, :user, :user_id
  end
end
