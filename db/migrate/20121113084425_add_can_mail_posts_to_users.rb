class AddCanMailPostsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :can_mail_posts, :boolean
  end
end
