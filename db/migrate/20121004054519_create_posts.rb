class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :owner
      t.string :content
      t.timestamp :post_date

      t.timestamps
    end
  end
end
