class AddYelledToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :yelled, :boolean
  end
end
