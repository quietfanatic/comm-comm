class AddBackgroundSettingsToSiteSettings < ActiveRecord::Migration
  def change
    add_column :site_settings, :background_image, :string
    add_column :site_settings, :background_gradient_top, :string
    add_column :site_settings, :background_gradient_bottom, :string
    add_column :site_settings, :navigation_text_color, :string
  end
end
