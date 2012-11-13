# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
CommComm::Application.initialize!


ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.logger = Rails.logger
settings = SiteSettings.settings
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: settings[:smtp_server],
  port: settings[:smtp_port],
  authentication: settings[:smtp_auto],
  user_name: settings[:smtp_username],
  password: settings[:smtp_password],
  enable_starttls_auto: settings[:smtp_starttls_auto],
  openssl_verify_mode: settings[:smtp_ssl_verify]
}
