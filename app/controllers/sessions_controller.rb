# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  # skip_before_action :authenticate_user!
  # skip_load_and_authorize_resource
  skip_forgery_protection

  def new_session_path(_scope)
    new_user_session_path
  end

  def omniauth_provider_key
    Rails.env.production? ? 'openid_connect' : 'developer'
  end

  def new
    case omniauth_provider_key
    when 'openid_connect'
      redirect_to user_openid_connect_omniauth_authorize_path
    else
      redirect_to user_developer_omniauth_authorize_path
    end
  end
end
