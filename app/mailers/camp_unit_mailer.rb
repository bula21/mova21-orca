# frozen_string_literal: true

class CampUnitMailer < ApplicationMailer
  def incomplete_notification
    @camp_unit = Unit.find params[:camp_unit_id]
    @lagerleiter = @camp_unit.lagerleiter

    I18n.with_locale(@camp_unit.language || @lagerleiter.language || I18n.default_locale) do
      mail(to: @lagerleiter.email, subject: I18n.t('camp_unit_mailer.incomplete_notification.subject'))
    end
  end

  def complete_notification
    @camp_unit = Unit.find params[:camp_unit_id]
    @lagerleiter = @camp_unit.lagerleiter

    I18n.with_locale(@camp_unit.language || @lagerleiter.language || I18n.default_locale) do
      mail(to: @lagerleiter.email, subject: I18n.t('camp_unit_mailer.complete_notification.subject'))
    end
  end

  def program_change_notification
    @program_change = UnitProgramChange.find params[:unit_program_change_id]
    @unit = @program_change.unit
    @lagerleiter = @unit.lagerleiter

    I18n.with_locale(@unit.language || @lagerleiter.language || I18n.default_locale) do
      mail(to: @lagerleiter.email, subject: I18n.t('camp_unit_mailer.program_change_notification.subject'))
    end
  end
end
