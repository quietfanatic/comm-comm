class AddActivityStuffToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :last_activity, :integer
  end
end
