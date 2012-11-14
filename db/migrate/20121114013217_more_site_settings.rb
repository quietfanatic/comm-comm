class MoreSiteSettings < ActiveRecord::Migration
  def change
    add_column :site_settings, :logo_text, :string
    add_column :site_settings, :logo_image, :string
    add_column :site_settings, :force_https, :boolean
    add_column :site_settings, :mail_subject_prefix, :string
    add_column :site_settings, :mail_from_address, :string
  end
end
