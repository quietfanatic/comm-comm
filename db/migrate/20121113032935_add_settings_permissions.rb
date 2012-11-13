class AddSettingsPermissions < ActiveRecord::Migration
  def change
    add_column :users, :can_change_appearance, :boolean
    add_column :users, :can_change_site_settings, :boolean
  end
end
