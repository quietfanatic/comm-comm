class AllowUndoingMerge < ActiveRecord::Migration
  def up
    add_column :site_settings, :last_merge_event, :integer
  end
end
