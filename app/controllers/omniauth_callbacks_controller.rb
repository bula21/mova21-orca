# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_forgery_protection

  def developer
    @user = User.from_omniauth(request.env['omniauth.auth'])

    return unless @user.persisted?

    sign_in_and_redirect @user, event: :authentication
    # set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
  end

  def failure
    redirect_to root_path
  end
end
