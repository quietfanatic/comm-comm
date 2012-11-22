class AddSmtpFromToSiteSettings < ActiveRecord::Migration
  def change
    add_column :site_settings, :smtp_from, :string
  end
end
