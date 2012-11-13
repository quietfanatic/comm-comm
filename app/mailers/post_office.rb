class PostOffice < ActionMailer::Base
  def test (user, to)
    if user.can_change_site_settings
      settings = SiteSettings.first_or_create
      ActionMailer::Base.raise_delivery_errors = true
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.logger = Rails.logger
      ActionMailer::Base.delivery_method = :smtp
      ActionMailer::Base.smtp_settings = {
        address: settings.smtp_server,
        port: settings.smtp_port,
        authentication: settings.smtp_auth,
        user_name: settings.smtp_username,
        password: settings.smtp_password,
        enable_starttls_auto: settings.smtp_starttls_auto,
        openssl_verify_mode: settings.smtp_ssl_verify
      }
      mail(
        to: to,
        from: settings.smtp_username,
        subject: 'Comm Comm Mail Test',
      )
    end
  end
end
