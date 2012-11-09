class RemovePostDateFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :post_date
  end

  def down
    add_column :posts, :post_date, :datetime
  end
end
