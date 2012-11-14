class PostOffice < ActionMailer::Base
  def set_settings
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
      return settings
  end
  def test (user, recipient)
    settings = set_settings
    if user.can_change_site_settings
      mail(
        to: recipients,
        from: settings.smtp_username,
        subject: 'Comm Comm Mail Test',
      )
    end
  end
  def post (user, post, recipients)
    settings = set_settings
    if post.board
      board = Board.find_by_id(post.board)
      board_name = board ? board.name : '<non-existant board id>'
    else
      board_name = 'Uncategorized'
    end
    @post = post
    mail(
      to: recipients,
      from: settings.smtp_username,
      subject: '[Comm Comm] ' + board_name
    )
  end
end
