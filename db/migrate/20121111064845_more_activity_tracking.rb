class MoreActivityTracking < ActiveRecord::Migration
  def up
    rename_column :topics, :last_activity, :last_event
    add_column :topics, :last_post, :integer
    add_column :topic_users, :last_reply, :integer
  end

  def down
    rename_column :topics, :last_event, :last_activity
    remove_column :topics, :last_post
    remove_column :topics, :topic_users
  end
end
