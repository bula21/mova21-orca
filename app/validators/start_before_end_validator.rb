# frozen_string_literal: true

class StartBeforeEndValidator < ActiveModel::Validator
  def validate(record)
    return if record.ends_at.blank? || record.starts_at.blank?
    return unless record.ends_at < record.starts_at

    record.errors.add(:start_not_before_end, I18n.t('activerecord.errors.messages.start_not_before_end'))
  end
end
