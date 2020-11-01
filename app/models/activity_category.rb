# frozen_string_literal: true

class ActivityCategory < ApplicationRecord
  extend Mobility

  belongs_to :parent, class_name: 'ActivityCategory', optional: true

  scope :without_self, ->(id) { where.not(id: id) }

  validates :label, presence: true
  translates :label, type: :string, locale_accessors: true, fallbacks: true

  def to_s
    label
  end
end
