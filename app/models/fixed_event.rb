# frozen_string_literal: true

class FixedEvent < ApplicationRecord
  extend Mobility
  validates_with StartBeforeEndValidator
  validates :starts_at, :ends_at, presence: true
  validates :stufe_ids, presence: true
  has_and_belongs_to_many :stufen
  translates :title, type: :string, locale_accessors: true, fallbacks: true
end
