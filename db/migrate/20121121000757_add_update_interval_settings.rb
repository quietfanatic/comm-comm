class AddUpdateIntervalSettings < ActiveRecord::Migration
  def change
    add_column :site_settings, :min_update_interval, :float, null: false, default: 4
    add_column :site_settings, :max_update_interval, :float, null: false, default: 32
  end
end
