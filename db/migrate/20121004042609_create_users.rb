class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.boolean :is_admin
      t.string :username
      t.string :visible_name
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
