class AddInvisibleToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :visible, :boolean, null: false, default: true
  end
end
