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
    ErrorLogger.capture_message(error_message, level: 'warning', extra: { errors: record.errors.full_messages })
  rescue StandardError => e
    ErrorLogger.capture_exception(e, extra: { record_class: record.class.name, record_id: record.id })
  end
end
