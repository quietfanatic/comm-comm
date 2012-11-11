class AddLastYellToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :last_yell, :integer
  end
end
