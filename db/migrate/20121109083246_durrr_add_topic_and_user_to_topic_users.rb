class DurrrAddTopicAndUserToTopicUsers < ActiveRecord::Migration
  def change
    add_column :topic_users, :topic, :integer
    add_column :topic_users, :user, :integer   
  end
end
