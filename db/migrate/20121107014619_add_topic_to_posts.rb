class AddTopicToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :topic, :integer
  end
end
