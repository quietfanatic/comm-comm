class AddPinnedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :pinned, :boolean
  end
end
