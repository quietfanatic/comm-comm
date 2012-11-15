class AddDefaultBoardToSettings < ActiveRecord::Migration
  def change
    add_column :site_settings, :initial_board, :integer
    add_column :site_settings, :sitewide_event_board, :integer
  end
end
