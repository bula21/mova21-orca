# frozen_string_literal: true

module ImportHelper
  def save_or_log_if_persisted_and_changed(record)
    return if record.new_record?

    save_or_log(record)
  end

  def save_or_log(record)
    return unless record.changed?
    return if record.save

    error_message = "Could not save #{record.class.name} with id #{record.id}"
    if Rollbar.configuration.enabled
      Rollbar.error(error_message, errors: record.errors.full_messages)
    else
      Rails.logger.error "#{error_message}: #{record.errors.full_messages.join(',')}"
    end
  end
end
