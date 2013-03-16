class AddAboutUs < ActiveRecord::Migration
  def change
    add_column :site_settings, :about_us_html, :text
  end
end
