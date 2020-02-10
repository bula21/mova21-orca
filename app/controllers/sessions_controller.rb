# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  # skip_before_action :authenticate_user!
  # skip_load_and_authorize_resource
  skip_forgery_protection

  def new_session_path(_scope)
    new_user_session_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    case omniauth_provider_key
    when 'openid_connect'
      redirect_uri = URI.escape(ENV['APP_BASE_URL'])
      "#{ENV['OIDC_ISSUER']}/protocol/openid-connect/logout?redirect_uri=#{redirect_uri}"
    else
      new_user_session_path
    end
  end

  def new
    case omniauth_provider_key
    when 'openid_connect'
      redirect_to user_openid_connect_omniauth_authorize_path
    else
      redirect_to user_developer_omniauth_authorize_path
    end
  end

  private

  def omniauth_provider_key
    ENV['OIDC_ISSUER'].present? ? 'openid_connect' : 'developer'
  end
end
