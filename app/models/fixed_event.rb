# frozen_string_literal: true

class FixedEvent < ApplicationRecord
  extend Mobility
  validates_with StartBeforeEndValidator
  validates :starts_at, :ends_at, presence: true

  translates :title, type: :string, locale_accessors: true, fallbacks: true
end
