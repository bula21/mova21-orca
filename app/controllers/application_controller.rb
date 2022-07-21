# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :set_locale
  before_action :set_paper_trail_whodunnit

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug { "Access denied on #{exception.action} #{exception.subject.inspect}" }
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_path, alert: exception.message }
    end
  end

  def set_locale
    I18n.locale = requested_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def requested_locale
    requested_locales = [params[:locale],
                         request.env['HTTP_ACCEPT_LANGUAGE'].try(:scan, /^[a-z]{2}/).try(:first)].compact
    requested_locales.find do |locale|
      I18n.available_locales.without(:en).include?(locale&.to_sym)
    end || I18n.default_locale
  end

  def new_session_path(_scope)
    new_user_session_path
  end

  protected

  def user_for_paper_trail
    return if current_user.blank?

    "##{current_user.id} #{current_user.full_name}"
  end
end
