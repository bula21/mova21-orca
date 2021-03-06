# frozen_string_literal: true

class CampUnitMailer < ApplicationMailer
  def incomplete_notification
    @camp_unit = Unit.find params[:camp_unit_id]
    @lagerleiter = @camp_unit.lagerleiter

    mail(to: @lagerleiter.email, subject: I18n.t('camp_unit_mailer.incomplete_notification.subject'))
  end

  def complete_notification
    @camp_unit = Unit.find params[:camp_unit_id]
    @lagerleiter = @camp_unit.lagerleiter

    mail(to: @lagerleiter.email, subject: I18n.t('camp_unit_mailer.complete_notification.subject'))
  end
end
