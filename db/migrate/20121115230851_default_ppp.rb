class DefaultPpp < ActiveRecord::Migration
  def up
    change_column :boards, :ppp, :integer, nil: false, default: 50
  end

  def down
    change_column :boards, :ppp, :integer
  end
end
