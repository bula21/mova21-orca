# frozen_string_literal: true

Devise.setup do |config|
  config.secret_key = ENV['DEVISE_SECRET_KEY']
  config.mailer_sender = ENV['MAIL_SENDER']
  config.pepper = ENV['DEVISE_PEPPER']

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
                  discovery: true
  # issuer: ENV["OIDC_ISSUER"],
  # uid_field: "preferred_username",
  # client_options: {
  #   scheme: 'http',
  #   port: 8080,
  #   host: 'auth',
  #   identifier: ENV["OIDC_CLIENT_ID"],
  #   secret: ENV["OIDC_CLIENT_SECRET_KEY"],
  #   redirect_uri: "#{ENV['APP_BASE_URL']}/auth/openid_connect/callback",
  # },

  config.omniauth :developer, fields: %w[email]
end
