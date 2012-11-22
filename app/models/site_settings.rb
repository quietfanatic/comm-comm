
class SiteSettings < ActiveRecord::Base

  attr_accessible :enable_mail, :smtp_server, :smtp_port, :smtp_auth, :smtp_username, :smtp_password, :smtp_starttls_auto, :smtp_ssl_verify, :send_test_to, :mail_from, :mail_subject_prefix, :last_merge_event, :min_update_interval, :max_update_interval

end





