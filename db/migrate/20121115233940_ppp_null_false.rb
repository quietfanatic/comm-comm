class PppNullFalse < ActiveRecord::Migration
  def up
    Board.all.each { |b| unless b.ppp then b.ppp = 50; b.save! end }
    change_column :boards, :ppp, :integer, default: 50, null: false
  end

  def down
    change_column :boards, :ppp, :integer, default: 50
     # This isn't exactly a reversible migration, but we're pretending it is.
    Board.all.each { |b| if b.ppp == 50 then b.ppp = nil; b.save! end }
  end
end
