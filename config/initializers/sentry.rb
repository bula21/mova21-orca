# frozen_string_literal: true

require 'active_support/parameter_filter'

if ENV['SENTRY_DSN'].present?
  Sentry.init do |config|
    filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
    config.before_send = lambda do |event, _hint|
      filter.filter(event.to_hash)
    end
  end
end

class ErrorLogger
  def self.capture_message(message, **options)
    if Sentry.initialized?
      Sentry.capture_message(message, **options)
    else
      Rails.logger.error("Capture Message: #{message}, Options: #{options.inspect}")
    end
  end

  def self.capture_exception(exception, **options)
    if Sentry.initialized?
      Sentry.capture_exception(exception, *options)
    else
      Rails.logger.error("Capture Error: #{exception&.message || exception}, Options: #{options.inspect}")
      Rails.logger.error(exception&.backtrace&.join("\n")) if exception&.backtrace
    end
  end
end
