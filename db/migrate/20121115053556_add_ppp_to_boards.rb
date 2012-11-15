class AddPppToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :ppp, :integer
  end
end
