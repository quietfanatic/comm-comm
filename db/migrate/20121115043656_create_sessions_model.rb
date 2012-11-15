class CreateSessionsModel < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.integer :user_id
      t.string  :token
      t.string  :user_agent
      
      t.timestamps
    end
  end
end
