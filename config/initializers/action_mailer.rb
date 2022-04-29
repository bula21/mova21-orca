# frozen_string_literal: true

ActionMailer::Base.tap do |config|
  config.default(
    from: ENV.fetch('MAIL_FROM', 'noreply@bula21.ch'),
    bcc: ENV.fetch('MAIL_BCC', nil)
  )
  config.default_url_options = { host: ENV.fetch('APP_BASE_URL', nil) }

  if ENV['SMTP_HOST'].present?
    config.delivery_method = :smtp
    config.smtp_settings = {
      address: ENV.fetch('SMTP_HOST'),
      port: ENV.fetch('SMTP_PORT', 587),
      user_name: ENV.fetch('SMTP_USER', nil),
      password: ENV.fetch('SMTP_PASSWORD', nil),
      authentication: ENV.fetch('SMTP_AUTH', 'plain'),
      enable_starttls_auto: true
    }
  end
end
