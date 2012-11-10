class AddOrderToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :order, :float, null: false, default: 0.0
  end
end
