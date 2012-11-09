class CreateTopicUsers < ActiveRecord::Migration
  def change
    create_table :topic_users do |t|
      t.integer :updated_to
    end
  end
end
