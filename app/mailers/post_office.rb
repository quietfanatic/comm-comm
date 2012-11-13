class PostOffice < ActionMailer::Base
  def test (user, to)
    if user.can_change_site_settings
      settings = SiteSettings.settings
      mail(
        to: to,
        from: settings[:smtp_username],
        subject: 'Comm Comm Mail Test',
      )
    end
  end
end
