class PutSiteSettingsInDatabase < ActiveRecord::Migration
  def change
    create_table :site_settings do |t|
      t.boolean :enable_mail
      t.string :smtp_server
      t.integer :smtp_port
      t.string :smtp_auth
      t.string :smtp_username
      t.string :smtp_password
      t.boolean :smtp_starttls_auto
      t.string :smtp_ssl_verify
      t.string :send_test_to

      t.timestamps
    end
  end
end
