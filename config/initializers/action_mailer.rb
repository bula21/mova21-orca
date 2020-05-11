# frozen_string_literal: true

ActionMailer::Base.tap do |config|
  config.default(
    from: ENV.fetch('MAIL_FROM', 'noreply@bula21.ch'),
    bcc: ENV.fetch('MAIL_BCC', nil)
  )
  config.default_url_options = { host: ENV['APP_BASE_URL'] }

  if ENV['SMTP_HOST'].present?
    config.delivery_method = :smtp
    config.smtp_settings = {
      address: ENV.fetch('SMTP_HOST'),
      port: ENV.fetch('SMTP_PORT', 587),
      user_name: ENV['SMTP_USER'],
      password: ENV['SMTP_PASSWORD'],
      authentication: ENV.fetch('SMTP_AUTH', 'plain'),
      enable_starttls_auto: true
    }
  end
end
