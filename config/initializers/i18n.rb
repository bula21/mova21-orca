# frozen_string_literal: true

# rubocop:disable Rails/OutputSafety
module I18n
  def self.j(key)
    translate(key).to_json.html_safe
  end
end
# rubocop:enable Rails/OutputSafety
