class AddTypingToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :type, :integer
    add_column :posts, :reference, :integer
  end
end
