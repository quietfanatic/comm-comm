class RenameTopicsToBoards < ActiveRecord::Migration
  def up
    rename_table :topics, :boards
    rename_table :topic_users, :board_users
    rename_column :posts, :topic, :board
    rename_column :board_users, :topic, :board
    rename_column :users, :can_edit_topics, :can_edit_boards
  end

  def down
    rename_table :boards, :topics
    rename_table :board_users, :topic_users
    rename_column :posts, :board, :topic
    rename_column :topic_users, :board, :topic
    rename_column :users, :can_edit_boards, :can_edit_topics
  end
end
