# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # before_action :authenticate_user!, :set_locale

  def set_locale
    I18n.locale = requested_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def requested_locale
    requested_locales = [params[:locale],
                         request.env['HTTP_ACCEPT_LANGUAGE'].try(:scan, /^[a-z]{2}/).try(:first)].compact
    requested_locales.find { |locale| I18n.locale_available?(locale) } || I18n.default_locale
  end

  def new_session_path(_scope)
    new_user_session_path
  end
end
