class ChangeSomeMailSettings < ActiveRecord::Migration
  def change
    rename_column :site_settings, :smtp_from, :mail_from
  end
end
