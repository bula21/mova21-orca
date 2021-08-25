# frozen_string_literal: true

module ActivityExecutionHelper
  def available_languages_for_frontend(activity_execution)
    activity_execution.languages.select { |_language, available| available }
                      .keys.map { |lang| lang.to_s.sub('language_', '') }
  end
end
