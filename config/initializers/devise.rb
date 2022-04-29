# frozen_string_literal: true

Devise.setup do |config|
  config.secret_key = ENV.fetch('DEVISE_SECRET_KEY', nil)
  config.mailer_sender = ENV.fetch('MAIL_SENDER', nil)
  config.pepper = ENV.fetch('DEVISE_PEPPER', nil)

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 11
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete

  # ==> Authenicated with Keycloak

  # TODO: Update when keycloak is set up
  config.omniauth :openid_connect,
                  scope: [:openid],
                  response_type: :code,
                  discovery: true,
                  issuer: ENV.fetch('OIDC_ISSUER', nil),
                  uid_field: 'preferred_username',
                  client_options: {
                    identifier: ENV.fetch('OIDC_CLIENT_ID', nil),
                    secret: ENV.fetch('OIDC_CLIENT_SECRET_KEY', nil),
                    redirect_uri: "#{ENV.fetch('APP_BASE_URL', nil)}/users/auth/openid_connect/callback"
                  }

  config.omniauth :developer, fields: %w[email pbs_id]
end

if Rails.env.development?
  OpenIDConnect.logger = WebFinger.logger = SWD.logger = Rack::OAuth2.logger = Rails.logger
  OpenIDConnect.debug!
end
